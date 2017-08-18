{:register, :make_loader} = require 'loadkit'
{:mkdir, :dir} = require 'lfs'
{:setfenv} = require'moonscript.util'

moonscript = require 'moonscript.base'
doc_moon = require 'lunadoc.doc_moon'
indent = require 'lunadoc.indent'

Project = require 'lunadoc.project'
Document = require 'lunadoc.document'
Template = require 'lunadoc.template'

register 'elua', (file) ->
  require('etlua').compile file\read '*a'

createDirectory = (path)->
  ppath = path\match '^(.+)/[^/]+'
  if ppath
    createDirectory ppath
  print '  ...creating folder: %s'\format path
  mkdir path

copyFile = (file, iprefix, oprefix, ofile) ->
  ofile or= file
  ipath = iprefix .. file
  opath = oprefix .. ofile

  print 'copying: %s'\format ipath
  print '  ...reading: %s'\format ipath

  ihandle,err=io.open ipath, 'r'
  unless ihandle
    return nil, err

  print '  ...writing: %s'\format opath

  ohandle,err=io.open opath, 'w'
  unless ohandle
    return nil, err

  ohandle\write ihandle\read'*a'

->
  project, reason = Project.fromConfiguration!

  unless project
    return nil, reason

  template, reason = switch type(project.tpl)
    when "string"
      Template.fromFilePath project.tpl
    when "function"
      Template project.tpl

  unless template
    return nil, reason

  for file in *project.files
    print 'reading file: %s'\format project.iprefix..file

    document, reason = Document.fromFileName project, file

    unless document
      io.stderr\write "warning: #{reason}\n"
      continue

    outputFilePath = project.oprefix..file\gsub('%.[^%.]+$', project.ext or '.html')

    print 'writing file %s'\format outputFilePath

    directory = outputFilePath\match '^(.+)/[^/]+'
    if directory
      createDirectory directory

    with file, reason = io.open outputFilePath, 'w'
      unless file
        return nil, reason

      \write template\render document
      \close!

  if type(project.files.copy) == 'table'
    for file in *project.files.copy
      status, err = copyFile project.iprefix, project.oprefix

      unless status
        return nil, err

  if type(project.tplcopy) == 'table'
    for file in *project.tplcopy
      ofile=file\gsub '^.+/', ''
      status , err = copyFile file, '', project.oprefix, ofile

      unless status
        return nil, err

  return true
