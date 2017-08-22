
drawType = (type, opt = {}) ->
	if type == "string" or type == "boolean" or type == "table" or type == "object" or type == "function"
		span class: "type has-text-primary", type
	-- Temporary. At some point, “type” won’t be a string anymore.
	elseif type == "nil" or type == "true" or type == "false"
		span class: "type has-text-warning", type
	else
		href = document\typeReference type

		if href
			if opt.noLinks
				span class: "type has-text-info", :href, type
			else
				a class: "type has-text-info", :href, type
		else
			span class: "type has-text-grey", type

drawArgumentsList = (value) ->
	if #value.arguments > 0
		div class: "arguments", ->
			h5 class: "heading", "Arguments"
			element "table", class: "table is-fullwidth arguments", ->
				thead ->
					tr ->
						th class: "name", "Argument"
						th class: "types", "Type"
						th class: "description", "Description"
				for arg in *value.arguments
					tr ->
						td ->
							if arg.assignedTo
								if arg.assignedTo == arg.name
									span class: "attribute", ->
										a class: "has-text-danger",
											"@#{arg.assignedTo}"
								else
									span class: "attribute", ->
										a class: "has-text-danger",
											"@#{arg.assignedTo}"
										text " = "

									span class: "has-text-success",
										arg.name
							else
								span class: "has-text-success",
									arg.name

						td ->
							if arg.type
								span class: "type", ->
									for type in *arg.type
										if type != arg.type[1]
											text " | "

										drawType type

						td ->
							if arg.description
								text arg.description

drawReturnValues = (value) ->
	if value.returnValues and #value.returnValues > 0
		div class: "return-values", ->
			h5 class: "heading", "Return values"
			element "table", class: "table is-fullwidth return-values", ->
				thead ->
					tr ->
						td class: "name" -- There for alignment reasons. =|
						th class: "types", "Type"
						th class: "description", "Description"
				for arg in *value.returnValues
					tr ->
						td ->
						td ->
							for type in *arg
								if type != arg[1]
									text ", "

								drawType type

						td ->
							text arg.description

drawSeeAlso = (value) ->
	h5 class: "heading", "See also"
	element "table", class: "table is-fullwidth", ->
		for reference in *value.see
			tr ->
				td ->
					href = document\typeReference reference
					a class: "has-text-info", :href, reference

				-- FIXME: Add summary/description here once global imports are done.

drawValue = (value, opt = {}) ->
	switch value.type
		when "method", "function"
			text " "

			span class: "arguments", ->
				if #value.arguments > 0
					text class: "parens", "("

					for arg in *value.arguments
						if arg != value.arguments[1]
							text ", "

						if arg.assignedTo
							if arg.assignedTo == arg.name
								span class: "argument", ->
									span {
										class: "attribute has-text-danger",
										"@" .. arg.name
									}
							else
								span class: "argument", ->
									span {
										class: "attribute has-text-danger",
										"@#{arg.assignedTo}"
									}
									text " = "
									a arg.name
						else
							span class: "argument has-text-success", arg.name

					span class: "parens", ") "
				else
					span class: "parens empty", "!"
					text " "

			text if value.type == "method"
				"⇒"
			else
				"→"

			span class: "return-value", ->
				text " "
				if #value.returnValues == 0
					span class: "has-text-primary",
						"object"

				rValues = value.returnValues
				for rValue in *rValues
					if rValue != rValues[1]
						text " | "

					span ->
						for type in *rValue
							if type != rValue[1]
								text ", "

							drawType type, opt

					text " "
		when "string"
			text "[["

			span class: "string has-text-warning", ->
				text value.value
			text "]]"
		when "number"
			text ""
			span class: "number", ->
				text value.value

drawCard = (field, root, category) ->
	key = field.key
	value = field.value

	div class: "card is-spaced", id: document\generateAnchor(field), ->
		div class: "card-header", ->
			h4 class: "card-header-title title is-3 prototype", ->
				-- FIXME: field.key, value.name ? Same thing, different places. That sucks.
				if key
					text key.value

				if category.key == "constructors" or category.key == "attributes"
					text root.name
					if field.name
						text "."
				text field.name

				span class: "subtitle is-4", ->
					if value.type != "function" and value.type != "method"
						text ": "

					drawValue value

		div class: "card-content", ->
			if value.comment
				div class: "content", ->
					raw value.comment

			if value.type == "function" or value.type == "method"
				drawArgumentsList value

				drawReturnValues value

		if value.see and #value.see > 0
			drawSeeAlso value

			for type in *{"info", "warning", "issue"}
				if value[type] and #value[type] > 0
					for message in *value[type]
						cssClass = switch type
							when "info"
								"is-info"
							when "warning"
								"is-warning"
							when "issue"
								"is-danger"

						div class: "tags has-addon", ->
							div class: "tag #{cssClass} is-medium", type\gsub "^.", (s) -> s\upper!
							div class: "tag is-dark is-medium", message

drawTOC = ->
	nav class: "menu", ->
		p class: "title is-5", "Table of Contents"

		index = document.index or (document.docTree and document.docTree.commentIndex)
		if index
			div ->
				-- FIXME: This is highly dependent on Discount’s implementation.
				index = index\gsub "<ul>", "<ul class=\"menu-list\">"

				-- No more than two levels of depth.
				index = index\gsub "\n   [^\n]*", ""

				print index
				raw index

		unless document.docTree
			return

		ul class: "menu-list", ->
			-- FIXME: Sort by directory? =/
			root = document.docTree

			if root.type == "table"
				for field in *root.elements
					li ->
						if field.key
							a href: "#" .. document\generateAnchor(field), ->
								p field.key.value

								p class: "content", ->
									code -> drawValue(field.value, noLinks: true)
			elseif root.type == "class"
				if #root.constructors > 0
					li ->
						p class: "menu-label", "Constructors"
						ul ->
							for field in *root.constructors
								li ->
									a href: "#" .. document\generateAnchor(field), ->
										p text field.name

										p class: "content", ->
											code -> drawValue(field.value, noLinks: true)
				if #root.instanceAttributes > 0
					li ->
						p class: "menu-label", "Instance"
						ul ->
							for field in *root.instanceAttributes
								li ->
									a href: "#" .. document\generateAnchor(field), ->
										p text field.name

										p class: "content", ->
											code -> drawValue(field.value, noLinks: true)
				if #root.attributes > 0
					li ->
						p class: "menu-label", "Class"
						ul ->
							for field in *root.attributes
								li ->
									a href: "#" .. document\generateAnchor(field), ->
										p text field.name

										p class: "content", ->
											code -> drawValue(field.value, noLinks: true)

drawIndex = ->
	div class: "section", ->
		categories = {
			{
				name: "Modules"
			}
			{
				name: "Classes"
				type: "class"
			}
			{
				name: "Guides"
				type: "guides"
			}
		}

		for category in *categories
			h3 class: "title is-3", category.name

			for doc in *project.documents
				if doc == document
					continue

				if category.type == "guides"
					if doc.docTree
						continue
				elseif category.type
					if not doc.docTree
						continue

					if doc.docTree.type != category.type
						continue
				else
					if not doc.docTree
						continue

					if doc.docTree.type == "class"
						continue

				div class: "card hero is-light", ->
					div class: "card-header", ->
						h3 class: "card-header-title", ->
							a {
								class: "title is-3 has-text-dark"
								href: document.root .. "/" .. doc.filename\gsub("%.[^.]*$", "") .. project.outputExtension
							}, ->
								if doc.docTree
									text doc.docTree.name
								else
									text doc.title

						if category.type == "class"
							a {
								class: "card-header-icon button is-medium is-success"
								href: document\linkTo(doc) .. "#--constructors"
							}, "Constructors"
							a {
								class: "card-header-icon button is-medium is-danger"
								href: document\linkTo(doc) .. "#--intanceAttributes"
							}, "Instance"
							a {
								class: "card-header-icon button is-medium is-info"
								href: document\linkTo(doc) .. "#--attributes"
							}, "Class"
						elseif not category.type
							a {
								class: "card-header-icon button is-medium is-info"
								href: document\linkTo(doc) .. "#--fields"
							}, "Fields"
				br!

raw "<?xml version='1.0' encoding='utf-8'?>\n"
raw "<?xml-stylesheet href='#{document.root}/bulma.css'?>\n"
raw "<?xml-stylesheet href='https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/github.min.css'?>\n"
-- Complected doctype needed for those weird deprecated HTML entities.
raw "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n"
html xmlns: "http://www.w3.org/1999/xhtml", ->
	head ->
		title "#{document.title} - #{project.title}"
		script src: "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"
		script src: "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.4.0/languages/moonscript.min.js"
		script "hljs.initHighlightingOnLoad();"
		style [[
			body {
				font-size: 14pt;
			}

			*.attribute, *.argument, *.return-value, *.prototype, table.arguments, table.return-values, .title .arguments {
				font-family: 'Ubuntu Mono', 'Monospace';
				font-weight: normal;
			}

			table.arguments tr td {
				padding-left: 1em;
			}

			#mainMenu, #footerMenu {
				background-color: #3273dc;

				-webkit-box-shadow: 0 2px 3px rgba(10, 10, 10, 0.2);
				box-shadow: 0 2px 3px rgba(10, 10, 10, 0.2);
			} #mainMenu a, #footerMenu a {
				color: #FFF;
			} #mainMenu a:hover, #footerMenu a:hover {
				color: #111;
			}

			.table .types, .table .name {
				width: 128px;
			}

			#mainMenu.breadcrumb ul li:before {
				color: #EEE;
			}

			.card-header-icon.button {
				margin: 8px;
			}
		]]
	body ->
		div class: "hero section is-light", ->
			div class: "container", ->
				div class: "level-left", ->
					div class: "level-item", ->
						h1 class: "title is-1", ->
							a class: "has-text-dark", href: document.root, ->
								text project.title

		div class: "breadcrumb has-bullet-separator is-medium", id: "mainMenu", ->
			div class: "container", ->
				ul ->
					li ->
						a class: "navbar-item", href: document.root .. "/index.xhtml", "Index"

					if not document.generateIndex
						li ->
							len = document.outputFilePath\len!
							href = document\linkTo document

							a class: "navbar-item", :href, document.title


		if document.generateIndex
			section class: "section", ->
				div class: "container", ->
					drawIndex!
		else
			div class: "columns", ->
				div class: "column is-one-quarter", ->
					section class: "section", ->
						drawTOC!

				div class: "column is-three-quarters", ->
					div class: "section", ->
						h1 class: "title is-1", ->
							if document.docTree
								switch document.docTree.type
									when "class"
										raw "Class <code>"
									else
										raw "Module <code>"

							raw document.title

							if document.docTree
								raw "</code>"

						if document.docTree
							h2 class: "subtitle is-3 module-type", ->
								text document.filename

						if document.body
							div class: "content", ->
								raw document.body

					if document.docTree
						root = document.docTree

						categories = {
							{
								name: "Constructors"
								key: "constructors"
							}
							{
								name: "Instance"
								key: "instanceAttributes"
							}
							{
								name: "Class"
								key: "attributes"
							}
						}

						div class: "section content", ->
							if root.comment
								raw root.comment


						if root.see and #root.see > 0
							section class: "section content", ->
								drawSeeAlso root

						if root.type == "class"
							for category in *categories
								if #root[category.key] == 0
									continue

								div class: "section", ->
									h3 class: "title is-3", id: "--" .. category.key, category.name

									for field in *root[category.key]
										br!
										drawCard field, root, category
						elseif root.type == "table"
							div class: "section", id: "--fields", ->
								for field in *root.elements
									br!
									drawCard field, root, {
										key: "class"
									}
						else
							pre ->
								text "Unimplemented. :(\n"
								text "Report an issue on Github providing your source file.\n"
								text "And this: #{root.type}"

		footer class: "", ->
			div class: "navbar", id: "footerMenu", ->
				div class: "container", ->
					div class: "navbar-brand", ->
						a class: "navbar-item", ->
							div class: "tags has-addons", ->
								div class: "tag is-light", "hestia"
								div class: "tag is-dark",  "#{project.__class.LUNRADOC_VERSION}"

						a class: "navbar-item", ->
							div class: "tags has-addons", ->
								div class: "tag is-light", "moonscript"
								div class: "tag is-dark",  "#{require("moonscript.version").version}"

						if project.title\lower! != "hestia"
							a class: "navbar-item", ->
								div class: "tags has-addons", ->
									div class: "tag is-light", "#{project.title}"
									div class: "tag is-dark",  "#{project.version}"

			div class: "footer", ->
				if project.author
					div class: "has-text-centered", ->
						div class: "heading", "with <3 from"
						div class: "title", project.author

						if project.date
							div class: "heading", "© #{project.date}"

