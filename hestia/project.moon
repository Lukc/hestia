
{:make_loader} = require "loadkit"
{:setfenv} = require "moonscript.util"
lfs = require "lfs"

moonscript = require "moonscript"

Document = require "hestia.document"
Template = require "hestia.template"

findMoon = make_loader "moon"
findCss = make_loader "css"
findJs = make_loader "js"

---
-- Represents a project.
---
class
	@LUNRADOC_VERSION: "0.5.0"

	---
	-- @constructor
	-- @return Project | nil, string
	@fromConfiguration: (filepath = "hestia.cfg") ->
		file, reason = io.open filepath, "r"

		unless file
			return nil, reason

		return @@.fromFile file

	---
	-- @constructor
	-- @return (Project)
	-- @return (nil, string) Could not parse the configuration file.
	@fromFile: (file) ->
		content = file\read "*a"

		code = moonscript.loadstring '{\n' .. content .. '\n}'

		unless code
			return nil, "Could not parse configuration file."

		with config = @@!
			for key, value in pairs code!
				switch key
					-- FIXME: Not complete.
					-- FIXME: Ugly names (we could keep legacy compat, though).
					-- FIXME: No checking of valid types and stuff. (automated type checking?)
					when "files", "inputPrefix", "outputDirectory", "title", "version", "date", "author", "outputExtension", "hljsstyle"
						config[key] = value

					-- FIXME: Check file existence and permissions.
					when "files", "templateFiles"
						config[key] = value
					when "template"
						config.template = value
					else
						print "warning: unrecognized key in configuration file: #{key}"

			\setDefaultValues!

	finalize: =>
		@outputDirectory = @outputDirectory\gsub "/%.$", ""

		@\updateFilesList!

		@documents = with __ = {} -- I really wish we had implicit variables.
			for fileName in *@files
				document, reason = Document.fromFileName self, fileName

				if document
					table.insert __, document
				else
					print "warning: could not import #{fileName}: #{reason}"

		print "Registering index."
		table.insert @documents, 1, Document.index self

	updateFilesList: =>
		getFiles = (path) ->
			coroutine.wrap ->
				for file in lfs.dir path
					if file\sub(1, 1) == "."
						continue

					file = path .. "/" .. file
					file = file\gsub("//*", "/")

					attributes = lfs.attributes file

					if attributes.mode == "directory"
						for nFile in getFiles file
							coroutine.yield nFile
					else
						coroutine.yield file

		@files = with files = [filename for filename in *(@files or {})]
			index = 1
			while index < #files
				file = files[index]

				attributes = lfs.attributes file

				if not attributes or attributes.mode == "directory"
					for nFile in getFiles file
						if nFile\match '%.moon$'
							print "Registering #{nFile}."
							table.insert files, nFile

					print "Unregistering #{file}"
					table.remove files, index
					continue

				index += 1

			.copy = (@files or {}).copy or {}

	setDefaultValues: =>
		@template or= findMoon "hestia.templates.bulma"
		@outputExtension or= ".xhtml"

		@discountFlags or= {
			"toc", "extrafootnote", "dlextra", "fencedcode"
		}

		@inputPrefix or= ''
		@outputDirectory or= ''

		@templateFiles or= {}

	loadTemplate: (template = @template) =>
		@template, reason = switch type template
			when "string"
				Template.fromFilePath template
			when "function"
				Template template
			else
				nil, "invalid value provided"

		unless @template
			return nil, reason

		return @template

	render: (document) =>
		with file, reason = io.open document.outputFilePath, "w"
			unless file
				return nil, reason

			\write @template\render document
			\close!

		true

	copyFiles: =>
		if type(@files.copy) == 'table'
			for file in *@files.copy
				status, err = @\copyFile file, @inputPrefix, @outputDirectory

				unless status
					return nil, err

		if type(@templateFiles) == 'table'
			for file in *@templateFiles
				ofile=file\gsub '^.+/', ''
				status , err = @\copyFile file, '', @outputDirectory, ofile

				unless status
					return nil, err

		true

	copyFile: (file, inputPrefix, outputDirectory, ofile) =>
		ofile or= file
		ipath = inputPrefix .. file
		opath = outputDirectory .. ofile

		print 'copying: %s'\format ipath
		print '  ... reading: %s'\format ipath

		ihandle,err=io.open ipath, 'r'
		unless ihandle
			return nil, err

		print '  ... writing: %s'\format opath
		ohandle,err=io.open opath, 'w'
		unless ohandle
			return nil, err

		ohandle\write ihandle\read'*a'

	__tostring: => "<Project: #{@title}>"

