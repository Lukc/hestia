
moonscript = require "moonscript.base"

class Template
	new: (renderer) =>
		-- Forcing it to ignore self.
		-- Why is this even a class? Consistency? Coherence? Ease of documentation? =/
		-- TODO: Decide if stuff will be downgraded to simple modules or not.
		@render = (self, document) ->
			renderer document

	render: (document) =>
		-- Templates would usually overwrite this method and do some
		-- operations with the document. Like printing html around and
		-- dumping its .body in the middle.
		document.body

	@fromMoon: (filePath) ->
		template, reason = moonscript.loadfile filePath

		unless template
			return nil, "moonscript could not load template file", reason, filePath

		{:render_html} = require "lunradoc.lapis.html"

		@@ (document) ->
			environment = {k, v for k, v in pairs _G}

			environment.document = document
			environment.project = document.project

			-- Not exactly thread-safe. We’ll probably never care.
			setfenv template, environment

			render_html template

	@fromEtlua: (filePath) ->
		file, reason = io.open filePath, "r"

		unless file
			return nil, reason

		content = file\read "*all"

		template = require("etlua").compile content

		file\close!

		@@ template

	@fromFilePath: (filePath) ->
		extension = filePath\match '^.*%.([^.]*)$'

		if extension == "moon"
			return @@.fromMoon filePath
		elseif extension == "elua"
			return @@.fromEtlua filePath
		else
			return nil, "unrecognized template format", extension

