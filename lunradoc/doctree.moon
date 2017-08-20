
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

---
-- Doctree generation below.
-- 
getValue = (tree, content) ->
	if type(tree[1]) == "table"
		if tree[1]
			return getValue tree[1], content

		-- No idea what I’m doing. =/
		return nil, "could not parse AST"

	with {}
		.type = tree[1]

		if tree[-1]
			.line = pos_to_line content, tree[-1]
			.comment = getPreCommentForLine content, .line

			if .comment
				result, err = discount.compile(.comment)

				if result
					.comment = result.body
				else
					print "(doctree) discount error: #{err}"

		if type(.type) == "table"
			print "[internal error]: getValue called on table"
			return nil
		--	.type = "table"
		--	.elements = {}
		--	for k,v in pairs tree[1]
		--		.elements[k] = getValue v, content
		elseif .type == "import"
			-- Do nothing?
			true
		elseif .type == "table"
			.elements = {}

			for i = 1, #tree[2]
				key = getValue tree[2][i][1], content
				value = getValue tree[2][i][2], content

				table.insert .elements, {
					:key, :value
				}
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
		elseif .type == "chain"
			.call = tree[2][2]
			.arguments = {}

			for i = 1, #tree[3][2]
				table.insert .arguments, getValue tree[3][2][i], content
		elseif .type == "string"
			.value = tree[3]
			.quoteType = tree[2]
		elseif .type == "key_literal" or .type == "number"
			.value = tree[2]
		elseif .type == "props"
			-- Not really parsed. The class thing will deal with it… probably.
			.value = tree[2]
		else
			print "[internal error]: unrecognized type #{.type}"

			.value = tree[2]


parseClass = (classBody) =>
	@name or= classBody.name
	@comment or= classBody.comment
	@methods or= {}
	@attributes or= {}
	@constructors or= {}

	for i = 1, #classBody.fields
		value = classBody.fields[i]

		key = value[1]
		attribute = value[2]

		-- Valid, documentable identifier.
		if key.type == "key_literal"
			array = if key.value == "new" or key.value == "__init"
			-- FIXME: Needs to be configurable…
				@constructors
			elseif attribute.type == "method"
				@methods
			else
				@attributes

			table.insert array, {
				name: key.value
				value: attribute
			}
		elseif key.type == "reference" and key.value\sub(1,1) == "@"
			table.insert @attributes, {
				name: key.value\sub(2, key.value\len!)
				value: attribute
			}

	self

isClassGen = (value) ->
	if value.type == "chain"
		if value.call == "Class"
			arg1 = value.arguments[1]
			arg2 = value.arguments[2]

			if arg1 and arg1.type == "table"
				fields = {}

				for _, e in pairs value.arguments[1].elements
					table.insert fields, {e.key, e.value}

				return {
					comment: value.comment

					:fields
				}

			if arg1 and arg1.type == "string" and arg2 and arg2.type == "table"
				fields = {}

				for _, e in pairs value.arguments[2].elements
					table.insert fields, {e.key, e.value}

				return {
					comment: value.comment

					:fields
				}

---
-- Hey, comment here.
parseDocTree = (string) ->
	tree, reason = parse.string string

	unless tree
		return nil, "could not parse moonscript", reason

	t = getValue(tree[#tree], string).type

	switch t
		when "class"
			parseClass {
				type: "class"
			}, getValue tree[#tree], string
		when "chain"
			chain = getValue tree[#tree], string

			classBody = isClassGen chain
			if classBody
				parseClass {
					type: "class"
				}, classBody
		else
			getValue tree, string

-- Actually, don’t use this. Ever.
toHtml = (value) ->
	render_html ->
		div ->
			p "type"
			p value.type

setmetatable {
	:toHtml
}, __call: (...) => parseDocTree ...

