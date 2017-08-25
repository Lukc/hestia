
discount = require "discount"

parse = require "moonscript.parse"

{:render_html} = require "hestia.lapis.html"

{:pos_to_line, :trim, :get_line} = require 'moonscript.util'

DocTree = class
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

---
-- Converts a Moonscript AST into… well… something close, but simplified and
-- that includes documentation comments, as well as some other sorts of metadata.
--
-- Takes care of parsing `@tags` and stuff.
--
-- Called a “DocTree” or “Documentation Tree” because the objective was to
-- create a tree of documentable (and possibly documented) objects that was
-- language-independent. Not sure I really did that, but, oh, well…
class MoonscriptParser
	---
	-- @return DocTree
	-- @return (nil, string) Moonscript parsing error or incomplete AST support.
	-- @param string (string) Moonscript code to parse. Usually the content of a file.
	@fromMoonscript: (string) ->
		self = @@!

		@input = string

		tree, reason = parse.string string

		unless tree
			return nil, "could not parse moonscript", reason

		@tree = tree

		topLevelValues = {}
		value, reason = do
			for i = 1, #tree
				topLevelValues[i] = @\getValue tree[i]

			topLevelValues[#tree]

		@topLevelValues = topLevelValues

		unless value
			return nil, reason

		-- This is a bit of a hack. We shouldn’t be doing this that way at all.
		if value.type == "reference"
			value = @\getTopLevelReference(value) or value

		if value.type == "table"
			for pair in *value.elements
				if pair.value.type == "reference"
					pair.value = @\getTopLevelReference(pair.value) or pair.value

		switch value.type
			when "class"
				@\parseClass {
					type: "class"
				}, value
			when "chain"
				chain = value

				classBody = @\isClassGen chain, string
				if classBody
					@\parseClass {
						type: "class"
					}, classBody
				else
					-- Well, good luck with it. =/
					chain
			else
				value

	getTopLevelReference: (value) =>
		for i = #@tree - 1, 1, -1
			t = @topLevelValues[i]
			if t.type == "assignment"
				if t.reference.value == value.value
					return t.value

	findPreCommentBegin: (code,line) =>
		if line <= 1
			return nil,'not found'

		sline = get_line code, line

		if sline
			sline=trim(sline..'#')\sub(1,-2)

			if sline\match '^%-%-%-'
				if not trim(get_line(code, line - 1))\match "^%-%-"
					return line

			if not sline\match '^%-%-'
				return nil,'broken block'

		return @\findPreCommentBegin code, line-1

	getPreCommentForLine: (code,line) =>
		endline = line-1
		startline , err = @\findPreCommentBegin code, endline

		if startline==nil
			return nil, err

		return table.concat([(trim get_line code, l)\sub l==startline and 5 or 4 for l=startline,endline], '\n') .. "\n"

	getAnnotation: (code, lineNo) =>
		line = trim(get_line code, lineNo)

		if line\match "%-%-%-"
			return line\gsub "^.*%-%-%-* *", ""

	---
	-- Converts a string into an iterator over its lines.
	getLines: (string) =>
		if string\sub(-1) ~= "\n"
			string ..= "\n"

		string\gmatch "(.-)\n"

	parseTags: (docTree, comment) =>
		for tagLine in @\getLines comment
			tagLine = trim tagLine

			unless tagLine\match "^@"
				continue

			tag, data = tagLine\match "^@([a-z][a-zA-Z0-9]*) *([^\n]*)"

			switch tag
				when "return"
					returnType, returnDesc = trim(data)\match "^(%([^)]+%))%s*(.*)"

					unless docTree.returnValues
						print "warning: trying to add @return to a non-callable."
						continue

					for rValueSet in (returnType or data)\gmatch "[^|]*"
						table.insert docTree.returnValues, {
							description: returnDesc
						}

						for rValue in rValueSet\gmatch "%w+"
							table.insert docTree.returnValues[#docTree.returnValues],
								rValue

						if #docTree.returnValues[#docTree.returnValues] == 0
							table.remove docTree.returnValues
				when "treturn"
					-- LDoc compatibility. =/
					@\parseTags docTree, "@return #{data\gsub "(%S+)%s*(.*)", (s1, s2) -> "(#{s1})"}"
				when "param"
					argName, argType, argDesc = trim(data)\match "^(%w+)%s*(%([^)]+%))%s*(.*)"

					findArg = (docTree, name) ->
						for arg in *(docTree.arguments or {})
							if arg.name == name
								return arg

					if argName
						arg = findArg docTree, argName

						if argType
							-- Removing parens.
							argType = argType\sub(2, argType\len! - 1)

						unless arg
							print "warning: documentation for unrecognized arg: #{argName}"
							continue

						-- FIXME: Actually split argType, plz
						arg.type = {argType}
						arg.description = argDesc
				when "tparam"
					-- LDoc compatibility. =/
					@\parseTags docTree, "@param #{data\gsub "(%S+)%s+(%S+)%s*(.*)", (s1, s2, s3) -> "#{s2} (#{s1}) #{s3}"}"
				when "constructor"
					docTree.tags or= {}
					docTree.tags.constructor = true
				when "info", "warning", "issue"
					docTree[tag] or= {}
					table.insert docTree[tag], data
				when "see"
					docTree.see or= {}
					for reference in data\gmatch "%S+"
						table.insert docTree.see, reference
				else
					print "warning: unhandled tag detected: #{tag}"

		return comment\gsub "\n@[a-z][^\n]*", "\n"

	docTrees: {
		string: (ast) =>
			DocTree.string ast[3], ast[2]
		table: (ast) =>
			elements = {}

			for i = 1, #ast[2]
				key = @\getValue ast[2][i][1]
				value = ast[2][i][2] and @\getValue ast[2][i][2]

				unless value
					value = key

					key = DocTree.number i

				table.insert elements, {
					:key, :value
				}

			DocTree.table elements
		key_literal: (ast) =>
			DocTree.string ast[2]
		number: (ast) =>
			DocTree.number ast[2]
		ref: (ast) =>
			DocTree.reference ast[2]
		self: (ast) =>
			DocTree.reference "@" .. ast[2]
		assign: (ast) =>
			-- FIXME: There could be multiple assignments over here.
			DocTree.assignment @\getValue(ast[2][1]), @\getValue(ast[3][1])
		"class": (ast) =>
			fields = {}

			getProps = (ast) ->
				unless ast[1]
					return

				{
					type: ast[1]
					value: ast[2]
				}

			for i = 1, #ast[4]
				value = getProps ast[4][i]

				if value.type == "props"
					key = @\getValue value.value[1]
					attribute = @\getValue value.value[2]

					table.insert fields, { key, attribute }

			name = ast[2]

			DocTree.class name, fields
		fndef: (ast) =>
			arguments = {}

			fndefType = if ast[4] == "fat"
				"method"
			else
				"function"

			returnValues = {}

			-- FIXME: Parse function body, and get metadata about the possible return values.
			--        (ie. documented return statements)
			--.body = ast[5]

			for i = 1, #ast[2]
				argument = ast[2][i]

				-- FIXME: Not only is this ugly, but default values are missing.
				if type(argument[1]) == "table"
					argument = @\getValue argument[1]

					if argument.type == "reference"
						-- FIXME: Could add a default documentation entry around here.
						argument = {
							assignedTo: argument.value\gsub '^@', ''
							name: argument.value\gsub '^@', ''
						}
					else
						print "??? FIXME", argument.type
						argument =
							name: argument.value
				else
					argument =
						name: argument[1]

				table.insert arguments, argument

			-- Build by hand because of two possible types.
			-- FIXME: Don’t build by hand, somehow.
			DocTree
				type: fndefType
				:returnValues
				:arguments
	}

	---
	-- 
	getValue: (ast) =>
		content = @input
		docTree = {}

		if @@.docTrees[ast[1]]
			docTree = @@.docTrees[ast[1]] self, ast

		unless docTree
			return with {}
				.type = ast[1]

				if type(.type) == "table"
					print "[internal error]: getValue called on table"
					return nil, "getValue called on something that starts with a table"
				elseif .type == "import"
					-- Do nothing?
					true
				elseif .type == "chain" or .type == "call"
					-- Not really documentable as-is. Special cases will be handled later… if need be.
					.ast = ast
				elseif .type == "if" or .type == "unless" or .type == "with" or .type == "foreach" or .type == "declare_with_shadows" or .type == "do" or .type == "exp"
					-- Not doing anything for now, even though some of those
					-- statements should probably be parsed. Like with.
					.ast = ast
				else
					print "[internal error]: unrecognized type #{.type}"

					.value = ast[2]
		
		with docTree
			if ast[-1]
				.line = pos_to_line content, ast[-1]
				.comment = @\getPreCommentForLine content, .line

				if .line
					if .comment
						.comment = @\parseTags docTree, .comment

					if .comment
						result, err = discount.compile(.comment, "toc", "fencedcode", "dlextra")

						if result
							.comment = result.body
							.commentIndex = result.index
						else
							print "(docast) discount error: #{err}"

					annotation = @\getAnnotation content, .line
					if annotation
						@\parseTags docTree, annotation

	parseClass: (Class, classBody) =>
		Class.name or= classBody.name
		Class.comment or= classBody.comment

		Class.instanceAttributes or= {}
		Class.attributes or= {}
		Class.constructors or= {} -- They’re class attributes too… should we remove the category?

		for i = 1, #classBody.fields
			value = classBody.fields[i]

			key = value[1]
			attribute = value[2]

			constructorTag = attribute.tags and attribute.tags.constructor

			-- Valid, documentable identifier.
			array = if key.type == "key_literal" or key.type == "string"
				if constructorTag or key.value == "new" or key.value == "__init"
					key.value = nil
				-- FIXME: Needs to be configurable…
					Class.constructors
				elseif attribute.type == "method"
					Class.instanceAttributes
				else
					Class.attributes
			elseif key.type == "reference" and key.value\sub(1,1) == "@"
				key.value = key.value\sub 2, key.value\len!

				if constructorTag
					Class.constructors
				else
					Class.attributes

			if array
				if array == Class.constructors
					if #attribute.returnValues == 0 and Class.name
						table.insert attribute.returnValues, {Class.name}

				table.insert array, {
					name: key.value
					value: attribute
				}

		Class

	isClassGen: (value) =>
		local name

		if value.type == "chain"
			ast = value.ast

			Class = @\getValue ast[2]
			if Class.type != "reference" or Class.value != "Class"
				return nil, "does not start with a reference to a class constructor"

			call = @\getValue ast[3]
			if call.type != "call"
				return nil, "not a call to a class constructor"

			arg1 = @\getValue call.ast[2][1]
			arg2 = call.ast[2][2] and @\getValue call.ast[2][2]

			fields = {}
			argsList, name = if arg1 and arg1.type == "table"
				arg1.elements
			elseif arg1 and arg1.type == "string" and arg2 and arg2.type == "table"
				arg2.elements ,arg1.value

			if argsList
				for _, e in pairs argsList
					table.insert fields, {e.key, e.value}

				return {
					comment: value.comment

					:fields
				}

