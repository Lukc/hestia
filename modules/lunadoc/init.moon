{:register, :make_loader} = require 'loadkit'
{:mkdir, :dir} = require 'lfs'
{:setfenv} = require'moonscript.util'

moonscript = require 'moonscript.base'
doc_moon = require 'lunadoc.doc_moon'
indent = require 'lunadoc.indent'

Configuration = require 'lunadoc.configuration'
Document = require 'lunadoc.document'
Template = require 'lunadoc.template'

register 'elua', (file) ->
  require('etlua').compile file\read '*a'

export find_css,find_js
find_css = make_loader 'css'
find_js = make_loader 'js'

createDirectory = (path)->
  ppath = path\match '^(.+)/[^/]+'
  if ppath
    createDirectory ppath
  print '  ...creating folder: %s'\format path
  mkdir path

copyFile = (ipath, opath)->
  print 'copying: %s'\format ipath
  print '  ...reading: %s'\format ipath
  ihandle,err=io.open ipath, 'r'
  return nil, err unless ihandle
  print '  ...writing: %s'\format opath
  ohandle,err=io.open opath, 'w'
  return nil, err unless ohandle
  ohandle\write ihandle\read'*a'

->
  project, err = Configuration.load!

  return nil, 'missing "lunadoc.cfg" file' if type(project)=='nil'
  return nil, err if type(project)~='table'

  project.iprefix or= ''
  project.oprefix or= ''

  template, reason = switch type(project.tpl)
    when "string"
      Template.fromFilePath project.tpl
    when "function"
      Template.fromFunction project.tpl
    when "nil"
      Template require 'lunadoc.templates.html'

  unless template
    return nil, reason

  project.discountFlags or= project.discount -- FIXME: LEGACY

  project.tplcopy or= {
    find_css 'lunadoc.templates.style'
    find_css 'lunadoc.templates.hlstyles.'.. (project.hljsstyle or 'monokai-sublime')
    find_js 'lunadoc.templates.hljs'
  }

  project.files = with files = [filename for filename in *project.files]
    index = 1
    while index < #files
      file = files[index]

      isDirectory = file\match '/$'
      if isDirectory
        for nFile in dir file
          if nFile == "." or nFile == ".." or nFile\match(".$") == "/"
            continue
          print "Registering #{nFile}."
          table.insert files, file ..  nFile

        table.remove files, index

      index += 1

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
      status, err = copyFile project.iprefix .. "/" .. file, project.oprefix .. "/" .. file

      unless status
        return nil, err

  if type(project.tplcopy) == 'table'
    for file in *project.tplcopy
      ofile=file\gsub '^.+/', ''
      status , err = copyFile file, project.oprefix .. "/" .. ofile

      unless status
        return nil, err

  return true
