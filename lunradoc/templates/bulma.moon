
drawCard = (field, root, category) ->
	key = field.key
	value = field.value

	div class: "card is-spaced", ->
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
													a class: "attribute has-text-danger",
														"@" .. arg.name
											else
												span class: "argument", ->
													a class: "attribute has-text-danger",
														"@#{arg.assignedTo}"
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

									a class: "class has-text-info",
										table.concat rValue, ", "
									text " "

		div class: "card-content", ->
			if value.type == "function" or value.type == "method"
				if #value.arguments > 0
					div class: "arguments", ->
						h5 class: "heading", "Arguments"
						element "table", class: "table is-fullwidth arguments", ->
							thead ->
								tr ->
									th "Argument"
									th "Type"
									th "Description"
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
											span class: "has-text-grey", ->
												text " is a "

											span class: "type", ->
												for type in *arg.type
													if type != arg.type[1]
														text " | "
													a class: "type", type

									td ->
										if arg.description
											text arg.description

			if value.comment
				div class: "content", ->
					raw value.comment

			if value.see and #value.see > 0
				h5 class: "heading", "See also"
				element "table", class: "table is-fullwidth", ->
					for reference in *value.see
						tr ->
							td ->
								a reference

							-- FIXME: Add summary/description here once global imports are done.

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

raw "<?xml version='1.0' encoding='utf-8'?>\n"
raw "<?xml-stylesheet href='https://cdnjs.cloudflare.com/ajax/libs/bulma/0.5.1/css/bulma.min.css'?>\n"
-- Complected doctype needed for those weird deprecated HTML entities.
raw "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n"
html xmlns: "http://www.w3.org/1999/xhtml", ->
	head ->
		title "#{document.title} - #{project.title}"
		style [[
			*.attribute, *.argument, *.return-value, *.prototype, table.arguments, .title .arguments {
				font-family: 'Ubuntu Mono', 'Monospace';
				font-weight: normal;
			}

			table.arguments tr td {
				padding-left: 1em;
			}
		]]
	body ->
		div class: "level hero section is-info is-bold", ->
			div class: "container", ->
				div class: "level-left", ->
					div class: "level-item", ->
						h1 class: "title is-1", ->
							a href: document.root, ->
								text project.title

		div class: "columns", ->
			div class: "column is-one-quarter", ->
				div class: "section", ->
					div class: "panel", ->
						div class: "panel-heading", "Files"

						for file in *document.project.files
							a {
								class: "panel-block"
								href: "#{document.root}/#{file\gsub("%.[^.]*$", document.project.outputExtension)}",

								-- FIXME: Parse the whole project, and use each document’s title.
								if file\match "%.moon$"
									({file\gsub("%.moon$", "")\gsub("/", ".")})[1]
								else
									file
							}

			div class: "column is-three-quarters", ->
				div class: "section", ->
					h1 class: "title is-1", ->
						raw document.title

					if document.docTree
						h2 class: "subtitle is-3 module-type", ->
							text document.filename

					if document.index
						div class: "content", ->
							raw document.index

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
							name: "Instance slots"
							key: "methods"
						}
						{
							name: "Class slots"
							key: "attributes"
						}
					}

					div class: "section content", ->
						if root.comment
							raw root.comment

						div class: "import", ->
							h5 class: "title is-5", "Import:"
							pre ->
								shortName = document.title\gsub('^.*%.', '')
								if root.type == "class"
									shortName = shortName\gsub '^.', (s) -> s\upper!

								text "#{root.name} = require '#{document.filename\gsub("%.[^.]*$", "")\gsub("/", ".")}'"

					if root.type == "class"
						for category in *categories
							if #root[category.key] == 0
								continue

							div class: "section", ->
								h3 class: "title is-3", category.name

								for field in *root[category.key]
									br!

									drawCard field, root, category
					elseif root.type == "table"
						div class: "section", ->
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

		footer class: "hero section is-info is-bold", ->
			div class: "container", ->
				div class: "level", ->
					div class: "level-item", ->
						div class: "has-text-centered", ->
							div class: "heading", "generated by"
							div class: "title", "lunradoc"

					div class: "level-item", ->
						if project.author
							div class: "has-text-centered", ->
								div class: "heading", "with <3 from"
								div class: "title", project.author

								if project.date
									div class: "heading", "© #{project.date}"

					div class: "level-item", ->
						div class: "has-text-centered", ->
							div class: "heading", "powered by"
							div class: "title", "moonscript"

