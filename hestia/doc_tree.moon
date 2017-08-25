
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

	---
	-- @constructor
	@string: (value, quoteType = nil) ->
		@@ {
			type: "string"
			:value, :quoteType
		}

	---
	-- @constructor
	@table: (elements) ->
		@@ {
			type: "table"
			:elements
		}

	---
	-- @constructor
	@number: (value) ->
		@@ {
			type: "number"
			:value
		}

	---
	-- @constructor
	@reference: (value) ->
		@@ {
			type: "reference"
			:value
		}

	---
	-- @constructor
	@assignment: (reference, value ) ->
		@@ {
			type: "assignment",
			:reference, :value
		}

	---
	-- @constructor
	@class: (name, fields) ->
		@@ {
			type: "class"
			:name, :fields
		}

