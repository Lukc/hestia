
argparse = require "argparse"

Project = require 'lunadoc.project'

ohshit = (reason) ->
	io.stderr\write "ERROR: #{reason}\n"
	os.exit(1)


argParser = with argparse "lunadoc", "A better documentation generator for Moonscript."
	with \argument "directory"
		\args "?"

	\option "-o --output",   "Directory in which to generate the documenatation."
	\option "-t --template", "Template to use for the documentation."
	\option "-s --suffix",   "Suffix to give to the generated files."

args = argParser\parse!

project, reason = Project.fromConfiguration!

unless project
	ohshit reason

if args.output
	project.oprefix = args.output\gsub("/*?", "/")
if args.suffix
	project.ext = args.suffix

project\loadTemplate args.template -- nil is fine

for document in project\getDocuments!
	outputFilePath = document.outputFilePath

	print 'writing file %s'\format outputFilePath

	document\createDirectories!

	s, r = project\render document
	unless s
		ohshit r

s, r = project\copyFiles!
unless s
	ohshit r

os.exit(0)
