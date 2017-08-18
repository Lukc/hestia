
{:mkdir} = require "lfs"
discount = require "discount"

doc_moon = require "lunadoc.doc_moon"

unpack = unpack or table.unpack

createDirectory = (path) ->
  ppath = path\match '^(.+)/[^/]+'

  if ppath
    createDirectory ppath

  print '  ... creating folder: %s'\format path

  mkdir path

class
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

		@outputFilePath = @project.oprefix .. @filename\gsub('%.[^%.]+$', @project.ext or '.html')

	__tostring: =>
		"<Document, #{@filename}>"

	importMoon: (project, filename, file) =>
		markdown = doc_moon file\read "*all"

		unless markdown
			return nil, "could not generate markdown from moon file"

		-- FIXME: IMHO, we shouldn’t generate the document as a whole, but bit by bit.
		data, reason = discount.compile(markdown, unpack(project.discountFlags))

		unless data
			return nil, "discount: " .. reason

		@body = data.body
		@index = data.index

	importMd: (project, filename, file) =>
		markdown = file\read "*all"

		data, reason = discount.compile markdown, unpack(project.discountFlags)

		unless data
			return nil, "discount: " .. reason

		@body = data.body
		@index = data.index

	@fromFileName: (project, filename) ->
		extension = filename\match "^.+%.(.+)$"
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

