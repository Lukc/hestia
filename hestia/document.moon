
{:mkdir, :attributes} = require "lfs"
discount = require "discount"

DocTree = require "hestia.doctree"

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
	---
	-- @param project  (Project) Project this document will be a part of.
	-- @param filename (string)  Filename to the document to parse and document.
	new: (@project, @filename) => --- @return Document
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

	__tostring: => --- @return string
		"<Document: \"#{@filename}\">"

	---
	-- Tries to parse the Moonscript file and generate a DocTree from it.
	--
	-- @return true | nil, string
	--
	-- @param project   (string)
	-- @param filename  (string)
	-- @param file      (file)
	importMoon: (project, filename, file) =>
		print "Parsing #{filename}."
		tree, reason = DocTree file\read "*all"

		if tree.type == "class"
			tree.name or= filename\gsub("%.moon", "")\gsub("^.*/", "")\gsub("^.", (s) -> s\upper!)

			@title = tree.name
		elseif tree.type == "table"
			tree.name or= filename\gsub("%.moon", "")\gsub("/", ".")
			@title = tree.name
		else
			tree.name or= filename\gsub("%.moon", "")\gsub("^.*/", "")

		unless tree
			@body = [[
<div class="error notification is-danger">
	Something bad happened while trying to generate the documentation for that file. :(
</div>
]]

			-- Not critical enough to make everything go to hell.
			print "warning: could not generate doctree from file: ", reason
			return

		@docTree = tree

		--@body = data.body
		--@index = data.index

	---
	-- Manual imports from Markdown file.
	--
	-- They’re basically read, piped through discount, and output as-is.
	--
	-- It sets the `@body` attribute and provides no docTree.
	--
	-- @return true | nil, string
	--
	-- @param project   (string)
	-- @param filename  (string)
	-- @param file      (file)
	importMd: (project, filename, file) =>
		markdown = file\read "*all"

		data, reason = discount.compile markdown, unpack(project.discountFlags)

		unless data
			return nil, "discount: " .. reason

		@body = data.body
		@index = data.index

	---
	-- Creates a Document from a given filename and attaches it to a given project.
	--
	-- @return Document | nil, string
	--
	-- @param project (Project)
	-- @param filename (string)
	--
	-- @constructor
	---
	@fromFileName: (project, filename) ->
		attr = attributes filename

		extension = filename\match "^.+%.(.+)$"
		unless extension
			return nil, "could not identify file type"

		methodName = "import" .. extension\gsub("^.", (s) -> s\upper!)

		file, reason = io.open filename, "r"
		unless file
			return nil, reason

		self = @@ project, filename

		if @@[methodName]
			_, reason = @@[methodName] self, project, filename, file

			if file
				file\close!

			if reason
				return nil, reason
			else
				return self
		else
			return nil, "unrecognized file"

	---
	-- Special constructor for the index of the documentation directory tree.
	-- @constructor
	@index: (project) ->
		self = @@ project, "."

		@outputFilePath = @project.outputDirectory .. "index" .. @project.outputExtension
		print @outputFilePath

		@title = "Index"

		-- No @body and no @doctree.
		@generateIndex = true

		self

	createDirectories: =>
		directory = @outputFilePath\match '^(.+)/[^/]+'

		if directory
			createDirectory directory

	typeReference: (string) =>
		module, key = string\match "^([^.]*)[\\.]([^.]*)$"
		unless module
			key = string\match "%.([^.]*)$"

		unless key
			module = string

		if key
			key = "#" .. key

		if module == ""
			return "#" .. key

		for document in *@project.documents
			if module == document.title
				return @root .. "/" .. document.filename\gsub("%.moon", @project.outputExtension) .. (key or "")

	generateAnchor: (docTree) =>
		-- FIXME: This function puts light on brokenness in DocTree.

		-- Classes.
		if docTree.name
			return docTree.name

		-- Tables. =/
		if docTree.key
			if type(docTree.key.value) == "string"
				return docTree.key.value
			else
				return docTree.key.value.value

		""

	linkTo: (document) =>
		-- start and end of substring.
		s = @project.outputDirectory\len! + 1
		e = document.outputFilePath\len!

		@root .. "/" .. document.outputFilePath\sub(s, e)

