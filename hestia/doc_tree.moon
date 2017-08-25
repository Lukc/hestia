
class DocTree
	new: (arg) =>
		for k,v in pairs arg
			@[k] = v

		@see or= {}
		@info or= {}
		@warning or= {}
		@issue or= {}

	__tostring: =>
		"<DocTree:#{@type}>"

	@string: (value, quoteType) ->
		@@ {
			type: "string"
			:value, :quoteType
		}

	@table: (elements) ->
		@@ {
			type: "table"
			:elements
		}

	@number: (value) ->
		@@ {
			type: "number"
			:value
		}

	@reference: (value) ->
		@@ {
			type: "reference"
			:value
		}

	@assignment: (reference, value ) ->
		@@ {
			type: "assignment",
			:reference, :value
		}

	@class: (name, fields) ->
		@@ {
			type: "class"
			:name, :fields
		}

