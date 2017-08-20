#!/usr/bin/env moon

argparse = require "argparse"

Project = require 'lunradoc.project'

ohshit = (reason) ->
	io.stderr\write "ERROR: #{reason}\n"
	os.exit(1)


argParser = with argparse "lunradoc", "Experimental documentation generator, mostly for Moonscript."
	with \argument "directory"
		\args "?"

	\option "-o --output",   "Directory in which to generate the documenatation."
	\option "-t --template", "Template to use for the documentation."
	\option "-s --suffix",   "Suffix to give to the generated files."

args = argParser\parse!

project, reason = Project.fromConfiguration (args.directory or ".") .. "/lunradoc.cfg"

unless project
	ohshit "Could not load configuration: #{reason}"

if args.directory
	if args.output and args.output\sub(1, 1) != "/"
		args.output = lfs.currentdir! .. "/" .. args.output .. "/"

	lfs.chdir args.directory

if args.output
	project.outputDirectory = args.output\gsub("/*?", "/")
if args.suffix
	project.outputExtension = args.suffix

project\loadTemplate args.template -- nil is fine

project\finalize!

for document in *project.documents
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
