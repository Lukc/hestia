
{:mkdir, :attributes} = require "lfs"
discount = require "discount"

DocTree = require "lunradoc.doctree"

unpack = unpack or table.unpack

createDirectory = (path) ->
	attr = attributes path
	if attr
		return attr.mode == "directory"

	ppath = path\match '^(.+)/[^/]+'

	if ppath
		createDirectory ppath

	print '  ... creating folder: %s'\format path

	mkdir path

---
-- Encapsulates a documented document’s data (duh).
--
-- Contains most of the documentation-import code.
---
class Document
	new: (@project, @filename) =>
		@file = @filename -- FIXME: LEGACY

		@root = @filename\gsub "[^/][^/]+/",  "../"
		@root = @root\gsub     "[^/]*$",      ""
		@root = @root\gsub     "^[^/]*$",     (m) -> m .. "."
		@root = @root\gsub     "/*$",         ""

		@title = @filename\gsub('%.[^%.]+$','')\gsub('/','.')
		if @project.moduleFilter
			@title = @project.moduleFilter @title

		@date or= project.date
		@author or= project.author

		@outputFilePath = @project.outputDirectory .. @filename\gsub('%.[^%.]+$', @project.outputExtension)

	__tostring: =>
		"<Document, #{@filename}>"

	importMoon: (project, filename, file) =>
		tree, reason = DocTree file\read "*all"

		unless tree
			return nil, "could not generate doctree from file", reason

		-- FIXME: IMHO, we shouldn’t generate the document as a whole, but bit by bit.
		--data, reason = discount.compile(markdown, unpack(project.discountFlags))

		@docTree = tree

		--@body = data.body
		--@index = data.index

	importMd: (project, filename, file) =>
		markdown = file\read "*all"

		data, reason = discount.compile markdown, unpack(project.discountFlags)

		unless data
			return nil, "discount: " .. reason

		@body = data.body
		@index = data.index

	---
	-- Creates a Document from a given filename and attaches it to a given project.
	---
	@fromFileName: (project, filename) ->
		extension = filename\match "^.+%.(.+)$"
		unless extension
			return nil, "could not identify file type"

		methodName = "import" .. extension\gsub("^.", (s) -> s\upper!)

		self = @@ project, filename

		if @@[methodName]
			file, reason = io.open filename, "r"
			unless file
				return nil, reason

			_, reason = @@[methodName] self, project, filename, file
			file\close!

			if reason
				return nil, reason
			else
				return self
		else
			return nil, "unrecognized file"

	createDirectories: =>
		directory = @outputFilePath\match '^(.+)/[^/]+'

		if directory
			createDirectory directory

