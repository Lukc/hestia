
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
		"<Document, #{@filename}>"

	---
	-- Tries to parse the Moonscript file and generate a DocTree from it.
	--
	-- @return true | nil, string
	--
	-- @param project   (string)
	-- @param filename  (string)
	-- @param file      (file)
	importMoon: (project, filename, file) =>
		tree, reason = DocTree file\read "*all"

		if tree.type == "class"
			tree.name or= filename\gsub("%.moon", "")\gsub("^.*/", "")\gsub("^.", (s) -> s\upper!)

			@title = "Class <code>#{tree.name}</code>"
		elseif tree.type == "table"
			tree.name or= filename\gsub("%.moon", "")\gsub("/", ".")
			@title = "Module <code>#{tree.name}</code>"
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

		-- FIXME: IMHO, we shouldn’t generate the document as a whole, but bit by bit.
		--data, reason = discount.compile(markdown, unpack(project.discountFlags))

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

