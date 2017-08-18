
{:make_loader} = require "loadkit"
{:setfenv} = require "moonscript.util"

moonscript = require "moonscript"

Document = require "lunadoc.document"
Template = require "lunadoc.template"

findCss = make_loader "css"
findJs = make_loader "js"

class
	@fromConfiguration: ->
		loader = make_loader "cfg", @@.fromFile, "./custom_?.lua;./?.lua"

		return loader "lunadoc"

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
					when "files", "iprefix", "oprefix", "title", "date", "author", "ext", "tpl", "tplcopy", "files", "hljsstyle"
						config[key] = value
					when "discount"
						print "warning: legacy option “discount” was renamed “discountFlags”"
						config.discountFlags = value
					else
						print "warning: unrecognized key in configuration file: #{key}"

			\updateFilesList!

			\setDefaultValues!

	updateFilesList: =>
		@files = with files = [filename for filename in *(@files or {})]
			index = 1
			while index < #files
				file = files[index]

				isDirectory = file\match '/$'
				if isDirectory
					for nFile in dir file
						if nFile == "." or nFile == ".." or nFile\match(".$") == "/"
							continue

						print "Registering #{nFile}."
						table.insert files, file ..  nFile

					table.remove files, index

				index += 1

			.copy = (@files or {}).copy or {}

	setDefaultValues: =>
		etluaLoader = make_loader "elua", (file) ->
			require("etlua").compile file\read "*all"

		@tpl or= etluaLoader "lunadoc.templates.html"

		@discountFlags or= {
			"toc", "extrafootnote", "dlextra", "fencedcode"
		}

		@iprefix or= ''
		@oprefix or= ''

		@tplcopy or= {
			findCss 'lunadoc.templates.style'
			findCss 'lunadoc.templates.hlstyles.'.. (@hljsstyle or 'monokai-sublime')
			findJs 'lunadoc.templates.hljs'
		}

	loadTemplate: (template = @tpl) =>
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
				status, err = @\copyFile file, @iprefix, @oprefix

				unless status
					return nil, err

		if type(@tplcopy) == 'table'
			for file in *@tplcopy
				ofile=file\gsub '^.+/', ''
				status , err = @\copyFile file, '', @oprefix, ofile

				unless status
					return nil, err

		true

	getDocuments: =>
		coroutine.wrap ->
			for fileName in *@files
				document, reason = Document.fromFileName self, fileName

				if document
					coroutine.yield document, fileName
				else
					print "warning: #{reason}"

	copyFile: (file, iprefix, oprefix, ofile) =>
		ofile or= file
		ipath = iprefix .. file
		opath = oprefix .. ofile

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

