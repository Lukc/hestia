
{:make_loader} = require "loadkit"
{:setfenv} = require "moonscript.util"

moonscript = require "moonscript"

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
		@files = with files = [filename for filename in *@files or {}]
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

	setDefaultValues: =>
		@tpl or= require "lunadoc.templates.html"

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

