
discount = require "discount"

unpack = unpack or table.unpack

DEFAULT_DISCOUNT_FLAGS = {"toc", "extrafootnote", "dlextra", "fencedcode"}

local Document

Document = class
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

	__tostring: =>
		"<Document>"

	importMoon: (project, filename, file) =>
		markdown = doc_moon file\read "*all"

		unless markdown
			return nil, "could not generate markdown from moon file"

		-- FIXME: IMHO, we shouldn’t generate the document as a whole, but bit by bit.
		data, reason = discount.compile(markdown, project.discountFlags or DEFAULT_DISCOUNT_FLAGS)

		unless data
			return nil, "discount: " .. reason

		@body = data.body
		@index = data.index

	importMd: (project, filename, file) =>
		markdown = file\read "*all"

		data, reason = discount.compile markdown, unpack(project.discountFlags or DEFAULT_DISCOUNT_FLAGS)

		unless data
			return nil, "discount: " .. reason

		@body = data.body
		@index = data.index

	@fromFileName: (project, filename) ->
		extension = filename\match "^.+%.(.+)$"
		methodName = "import" .. extension\gsub("^.", (s) -> s\upper!)

		self = Document project, filename

		if @@[methodName]
			file = io.open filename, "r"
			_, reason = @@[methodName] self, project, filename, file
			file\close!

			if reason
				return nil, reason
			else
				return self
		else
			return nil, "unrecognized file"

Document

