
{:make_loader} = require "loadkit"
{:setfenv} = require "moonscript.util"

moonscript = require "moonscript"

local Configuration

Configuration = class
	@load: ->
		loader = make_loader "cfg", Configuration.fromFile, "./custom_?.lua;./?.lua"

		return loader "lunadoc"

	@fromFile: (file) ->
		content = file\read "*a"

		code = moonscript.loadstring '{\n' .. content .. '\n}'

		unless code
			return nil, "Could not parse configuration file."

		with config = Configuration!
			for key, value in pairs code!
				switch key
					-- FIXME: Not complete.
					-- FIXME: Ugly names (we could keep legacy compat, though).
					when "files", "iprefix", "oprefix", "title", "date", "author", "ext", "tpl"
						config[key] = value
					else
						print "warning: unrecognized key in configuration file: #{key}"


Configuration

