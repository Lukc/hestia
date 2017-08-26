
drawType = (Type, opt = {}) ->
	if Type == "string" or Type == "boolean" or Type == "table" or Type == "object" or Type == "function"
		span class: "Type has-text-primary", Type
	-- Temporary. At some point, “Type” won’t be a string anymore.
	elseif Type == "nil" or Type == "true" or Type == "false"
		span class: "type has-text-warning", Type
	else
		href = document\typeReference Type

		if href
			if opt.noLinks
				span class: "type has-text-info", :href, Type
			else
				a class: "type has-text-info", :href, Type
		else
			span class: "type has-text-grey", Type

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
							else -- XXX: what the hell
								span class: "argument", ->
									span {
										class: "attribute has-text-danger",
										"@#{arg.assignedTo}"
									}
									text " = "
									a arg.name
						else
							span class: "argument has-text-success", arg.name

						unless opt.short
							if arg.value
								text " = "
								drawValue arg.value

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
		when "union"
			for type in *value.value
				if type != value.value[1]
					text " | "
				drawType type, opt
		when "string"
			text "\""

			span class: "string has-text-warning", ->
				text value.value

			text "\""
		when "number"
			span class: "hestia-number", ->
				text tostring value.value
		when "reference"
			if value.value\sub(1, 1) == "@"
				span class: "attribute has-text-danger", value.value
			else
				text value.value
		when "table"
			span class: "has-text-grey", "{"

			if opt.short
				span class: "has-text-grey", " … "
			else
				text " #{#value.elements} elements "

			span class: "has-text-grey", "}"
		when "class"
			span class: "class has-text-danger", ->
				text "class"

				if value.name
					text " "
					span class: "has-text-info", value.name

drawContent = (value) ->
	switch value.type
		when "function", "method"
			drawArgumentsList value

			drawReturnValues value
		when "table"
			element "table", class: "table is-fullwidth", ->
				for element in *value.elements
					tr ->
						td class: "hestia-table-key", ->
							text "["
							drawValue element.key
							text "]"
							text ": "
						td ->
							drawValue element.value
		when "class"
			-- That part is going to be hard. Probably.
			true

drawCard = (field, root, section) ->
	key = field.key
	value = field.value

	div class: "card is-spaced", id: document\generateAnchor(field), ->
		div class: "card-header", ->
			h4 class: "card-header-title title is-3 prototype", ->
				if section
					if section.title == "Constructors" or not section.title
						text tostring root.name\gsub ".*%.", ""

						if (key and key.value) or field.name
							text "."

				-- FIXME: field.key, value.name ? Same thing, different places. That sucks.
				if key
					text key.value
				else
					text field.name

				span class: "subtitle is-4", ->
					if value.type != "function" and value.type != "method"
						text ": "

					drawValue value

		div class: "card-content", ->
			if value.comment and section
				-- no section == root object.
				-- Its comment will be displayed at the top of the page.
				div class: "content", ->
					raw value.comment

			drawContent value

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

						div class: "tags has-addons", ->
							div class: "tag #{cssClass} is-medium", tostring type\gsub "^.", (s) -> s\upper!
							div class: "tag is-dark is-medium", message

getElements = (array) ->
	[e for e in *array when not e.value.hidden]

getSections = (root) ->
	if root.type == "table"
		{
			{
				id: "fields"
				elements: getElements root.elements
				drawTOCElement: (element) ->
					if element.key
						a href: "#" .. document\generateAnchor(element), ->
							p element.key.value

							p class: "content", ->
								code -> drawValue(element.value, noLinks: true, short: true)
			}
		}
	elseif root.type == "class"
		{
			{
				title: "Constructors"
				id: "constructors"
				elements: getElements root.constructors
				drawTOCElement: (element) ->
					a href: "#" .. document\generateAnchor(element), ->
						p text element.name

						p class: "content", ->
							code -> drawValue(element.value, noLinks: true, short: true)
			}
			{
				id: "instanceAttributes"
				title: "Instance"
				elements: getElements root.instanceAttributes
				drawTOCElement: (element) ->
					a href: "#" .. document\generateAnchor(element), ->
						p text element.name

						p class: "content", ->
							code -> drawValue(element.value, noLinks: true, short: true)
			}
			{
				id: "attributes"
				title: "Class"
				elements: getElements root.attributes
				drawTOCElement: (element) ->
					a href: "#" .. document\generateAnchor(element), ->
						p text element.name

						p class: "content", ->
							code -> drawValue(element.value, noLinks: true, short: true)
			}
		}
	else
		{}

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

				raw index

		unless document.docTree
			return

		ul class: "menu-list", ->
			-- FIXME: Sort by directory? =/
			root = document.docTree

			sections = getSections root

			for section in *sections
				if #section.elements == 0
					continue

				li ->
					if section.title
						p class: "menu-label", section.title

					ul ->
						for element in *section.elements
							section.drawTOCElement element

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
							if #doc.docTree.constructors > 0
								a {
									class: "card-header-icon button is-medium is-success"
									href: document\linkTo(doc) .. "#--constructors"
								}, "Constructors"
							if #doc.docTree.instanceAttributes > 0
								a {
									class: "card-header-icon button is-medium is-danger"
									href: document\linkTo(doc) .. "#--instanceAttributes"
								}, "Instance"
							if #doc.docTree.attributes > 0
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

			.hestia-table-key {
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

						div class: "section content", ->
							if root.comment
								raw root.comment

						sections = getSections root

						if root.see and #root.see > 0
							section class: "section content", ->
								drawSeeAlso root

						if #sections > 0
							for section in *sections
								if #section.elements == 0
									continue

								element "section", class: "section", ->
									if section.title
										h3 class: "title is-3", id: "--" .. section.id,
											section.title

									for element in *section.elements
										unless element == section.elements[1]
											br!

										drawCard element, root, section
						elseif root.type == "function" or root.type == "method"
							drawCard {value: root}, root
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
								div class: "tag is-light", "Hestia Documentation"
								div class: "tag is-dark",  "#{project.__class.LUNRADOC_VERSION}"

						a class: "navbar-item", ->
							div class: "tags has-addons", ->
								div class: "tag is-light", "moonscript"
								div class: "tag is-dark",  "#{require("moonscript.version").version}"

						if project.title\lower! != "hestia documentation"
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

