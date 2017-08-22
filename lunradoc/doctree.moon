
discount = require "discount"

parse = require "moonscript.parse"

{:render_html} = require "lunradoc.lapis.html"

---
-- Imports from lunadoc’s code, because.
--
-- FIXME: Test the comments extractor. It’s buggy as hell. Everything’s an unsupported cornercase.
---

{:pos_to_line, :trim, :get_line} = require 'moonscript.util'

findPreCommentBegin=(code,line)->
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

	return findPreCommentBegin code, line-1

getPreCommentForLine=(code,line)->
	endline=line-1
	startline,err=findPreCommentBegin code, endline

	if startline==nil
		return nil, err

	return table.concat([(trim get_line code, l)\sub l==startline and 5 or 4 for l=startline,endline], '\n') .. "\n"

getAnnotation = (code, lineNo) ->
	line = trim(get_line code, lineNo)

	if line\match "%-%-%-"
		return line\gsub "^.*%-%-%-* *", ""

getLines = (string) ->
	if string\sub(-1) ~= "\n"
		string ..= "\n"

	string\gmatch "(.-)\n"

parseTags = (self, comment) ->
	for tagLine in getLines comment
		tagLine = trim tagLine

		unless tagLine\match "^@"
			continue

		tag, data = tagLine\match "^@([a-z][a-zA-Z0-9]*) *([^\n]*)"

		switch tag
			when "return"
				returnType, returnDesc = trim(data)\match "^(%([^)]+%))%s*(.*)"

				unless self.returnValues
					print "warning: trying to add @return to a non-function."
					continue

				for rValueSet in (returnType or data)\gmatch "[^|]*"
					table.insert self.returnValues, {
						description: returnDesc
					}

					for rValue in rValueSet\gmatch "%w+"
						table.insert self.returnValues[#self.returnValues],
							rValue

					if #self.returnValues[#self.returnValues] == 0
						table.remove self.returnValues
			when "treturn"
				-- LDoc compatibility. =/
				parseTags self, "@return #{data\gsub "(%S+)%s*(.*)", (s1, s2) -> "(#{s1})"}"
			when "param"
				argName, argType, argDesc = trim(data)\match "^(%w+)%s*(%([^)]+%))%s*(.*)"

				findArg = (self, name) ->
					for arg in *(self.arguments or {})
						if arg.name == name
							return arg

				if argName
					arg = findArg self, argName

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
				parseTags self, "@param #{data\gsub "(%S+)%s+(%S+)%s*(.*)", (s1, s2, s3) -> "#{s2} (#{s1}) #{s3}"}"
			when "constructor"
				self.tags or= {}
				self.tags.constructor = true
			when "info", "warning", "issue"
				self[tag] or= {}
				table.insert self[tag], data
			when "see"
				for reference in data\gmatch "%S+"
					table.insert self.see, reference
			else
				print "warning: unhandled tag detected: #{tag}"

	return comment\gsub "\n@[a-z][^\n]*", "\n"

---
-- Doctree generation below.
-- 
getValue = (tree, content) ->
	with self = {}
		.type = tree[1]

		.see = {}

		if tree[-1]
			.line = pos_to_line content, tree[-1]
			.comment = getPreCommentForLine content, .line

		if type(.type) == "table"
			print "[internal error]: getValue called on table"
			return nil, "getValue called on something that starts with a table"
		elseif .type == "import"
			-- Do nothing?
			true
		elseif .type == "table"
			.elements = {}

			for i = 1, #tree[2]
				key = getValue tree[2][i][1], content
				value = tree[2][i][2] and getValue tree[2][i][2], content

				unless value
					value = key

					key = {
						type: "number"
						value: i
					}

				table.insert .elements, {
					:key, :value
				}

--			if type(tree[2][1][1]) != "string"
--				for i = 1, #tree[2][1]
--					value = getValue tree[2][1][i], content
--					key = {
--						type: "number"
--						value: i
--					}

--					table.insert .elements, {
--						:key, :value
--					}
		elseif .type == "assign"
			.reference = getValue tree[2][1], content
			.value = getValue tree[3][1], content
		elseif .type == "ref"
			.type = "reference"
			.value = tree[2]
		elseif .type == "self"
			.type = "reference"
			.value = "@" .. tree[2]
		elseif .type == "class"
			.fields = {}

			for i = 1, #tree[4]
				value = getValue tree[4][i], content

				if value.type == "props"
					key = getValue value.value[1], content
					attribute = getValue value.value[2], content

					table.insert .fields, { key, attribute }

			.name = tree[2]
		elseif .type == "fndef"
			.arguments = {}

			if tree[4] == "fat"
				.type = "method"
			else
				.type = "function"

			.returnValues = {}

			-- FIXME: Parse function body, and get metadata about the possible return values.
			--        (ie. documented return statements)
			--.body = tree[5]

			for i = 1, #tree[2]
				argument = tree[2][i]

				-- FIXME: Not only is this ugly, but default values are missing.
				if type(argument[1]) == "table"
					argument = getValue argument[1], content

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

				table.insert .arguments, argument
		elseif .type == "string"
			.value = tree[3]
			.quoteType = tree[2]
		elseif .type == "key_literal" or .type == "number"
			.value = tree[2]
		elseif .type == "props"
			-- Not really parsed. The class thing will deal with it… probably.
			.value = tree[2]
		elseif .type == "chain" or .type == "call"
			-- Not really documentable as-is. Special cases will be handled later… if need be.
			.ast = tree
		else
			print "[internal error]: unrecognized type #{.type}"

			.value = tree[2]

		if .line
			if .comment
				.comment = parseTags self, .comment

			if .comment
				result, err = discount.compile(.comment)

				if result
					.comment = result.body
				else
					print "(doctree) discount error: #{err}"

			annotation = getAnnotation content, .line
			if annotation
				parseTags self, annotation


parseClass = (classBody) =>
	@name or= classBody.name
	@comment or= classBody.comment

	@instanceAttributes or= {}
	@attributes or= {}
	@constructors or= {} -- They’re class attributes too… should we remove the category?

	for i = 1, #classBody.fields
		value = classBody.fields[i]

		key = value[1]
		attribute = value[2]

		constructorTag = attribute.tags and attribute.tags.constructor

		-- Valid, documentable identifier.
		array = if key.type == "key_literal"
			if constructorTag or key.value == "new" or key.value == "__init"
				key.value = nil
			-- FIXME: Needs to be configurable…
				@constructors
			elseif attribute.type == "method"
				@instanceAttributes
			else
				@attributes
		elseif key.type == "reference" and key.value\sub(1,1) == "@"
			key.value = key.value\sub 2, key.value\len!

			if constructorTag
				@constructors
			else
				@attributes

		if array
			if array == @constructors
				if #attribute.returnValues == 0 and @name
					table.insert attribute.returnValues, {@name}

			table.insert array, {
				name: key.value
				value: attribute
			}

	self

isClassGen = (value, code) ->
	local name

	if value.type == "chain"
		ast = value.ast

		Class = getValue ast[2], code
		if Class.type != "reference" or Class.value != "Class"
			return nil, "does not start with a reference to a class constructor"

		call = getValue ast[3], code
		if call.type != "call"
			return nil, "not a call to a class constructor"

		arg1 = getValue call.ast[2][1], code
		arg2 = call.ast[2][2] and getValue call.ast[2][2], code

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


---
-- Converts a Moonscript AST into… well… something close, but simplified and
-- that includes documentation comments, as well as some other sorts of metadata.
--
-- Takes care of parsing `@tags` and stuff.
--
-- Called a “DocTree” or “Documentation Tree” because the objective was to
-- create a tree of documentable (and possibly documented) objects that was
-- language-independent. Not sure I really did that, but, oh, well…
(string) ->
	tree, reason = parse.string string

	unless tree
		return nil, "could not parse moonscript", reason

	success, value, reason = pcall ->
		getValue(tree[#tree], string)

	unless success
		return nil, value

	unless value
		return nil, reason

	t = value.type

	switch t
		when "class"
			parseClass {
				type: "class"
			}, value
		when "chain"
			chain = value

			classBody = isClassGen chain, string
			if classBody
				parseClass {
					type: "class"
				}, classBody
			else
				-- Well, good luck with it. =/
				chain
		else
			value

