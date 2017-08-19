raw "<?xml version='1.0' encoding='utf-8'?>\n"
raw "<?xml-stylesheet href='#{document.root}/style.css'?>\n"

-- Complected doctype needed for those weird deprecated HTML entities.
raw "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n"

html xmlns: "http://www.w3.org/1999/xhtml", ->
	head ->
		title "#{document.title} - #{project.title}"
		script type: "text/javascript", src: "#{document.root}hljs.js"
		script type: "text/javascript", "hljs.initHighlightingOnLoad();"
		if document.css
			raw table.concat document.css, ''
	body ->
		aside class: "sidebar", ->
			div class: "head", project.title
			ul
			for file in *project.files
				moduleName = file\gsub("%.[^%.]+$", "")\gsub("/", ".")
				if project.modulefilter
					moduleName = project.modulefilter moduleName
				href = file\gsub("%.[^%.]+$", project.ext or ".html")

				li ->
					a :href, moduleName

		section class: "header", ->
			h1 ->
				text title
				raw " - "
				text project.title

			if project.date and project.author
				span class: "copy", ->
					raw "© "
					text project.date
					text " "
					text project.author

		if document.index
			aside class: "index", ->
				div class: "head", ->
					text document.title

				raw document.index

		section class: "body", ->
			raw document.body

