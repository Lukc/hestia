import register,make_loader from require 'loadkit'
import compile from require'discount'
import mkdir from require'lfs'
moonscript = require'moonscript.base'
doc_moon=require 'lunadoc.doc_moon'
indent=require'lunadoc.indent'

register 'elua', (file)->
  require'etlua'.compile file\read'*a'

export find_css,find_js
find_css=make_loader 'css'
find_js=make_loader 'js'

loadcfg=(file)->
  fn,err=moonscript.loadstring '{\n' .. indent(file\read'*a', '  ') .. '\n}'
  return fn,nil,err unless fn
  fn!,true

cfgloader=make_loader 'cfg', loadcfg, './?.lua'

mkdirp=(path)->
  ppath=path\match '^(.+)/[^/]+'
  if ppath
    mkdirp ppath
  print '  ...creating folder: %s'\format path
  mkdir path

cpfile=(file, iprefix, oprefix, ofile)->
  ofile or=file
  ipath=iprefix .. file
  opath=oprefix .. ofile
  print 'copying: %s'\format file
  print '  ...reading: %s'\format ipath
  ihandle,err=io.open ipath, 'r'
  return nil, err unless ihandle
  print '  ...writing: %s'\format opath
  ohandle,err=io.open opath, 'w'
  return nil, err unless ohandle
  ohandle\write ihandle\read'*a'

->
  project,status,err=cfgloader 'lunadoc'

  return nil, 'missing "lunadoc.cfg" file' unless project
  return nil, err unless status

  project.iprefix or= ''
  project.oprefix or= ''

  tpl=project.tpl or require 'lunadoc.templates.html'

  discountflags=project.discount or {'toc', 'extrafootnote', 'dlextra', 'fencedcode'}

  project.tplcopy or= {
    find_css 'lunadoc.templates.style'
    find_css 'lunadoc.templates.hljs-monokai'
    find_js 'lunadoc.templates.hljs'
  }

  for file in *project.files
    print 'reading file: %s'\format project.iprefix..file
    handle,err=io.open project.iprefix .. file
    return nil, err unless handle
    document = switch file\match '^.+%.(.+)$'
      when 'moon'
        print '  ...using lunadoc.doc_moon'
        assert compile(assert(doc_moon handle\read'*a'), unpack discountflags)
      when 'md'
        print '  ...using discount'
        assert compile(handle\read'*a', unpack discountflags)
    handle\close!
    document.file = file
    document.project = project
    document.title or= file\gsub('%.[^%.]+$','')\gsub('/','.')
    document.date or= project.date
    document.author or= project.author
    ofilepath=project.oprefix..file\gsub('%.[^%.]+$','.html')
    print 'writing file %s'\format ofilepath
    dir=ofilepath\match '^(.+)/[^/]+'
    mkdirp dir if dir
    handle,err=io.open ofilepath, 'w'
    return nil, err unless handle
    with handle
      \write tpl document
      \close!
  if type(project.files.copy)=='table'
    for file in *project.files.copy
      status,err=cpfile file, project.iprefix, project.oprefix
      return nil, err unless status
  if type(project.tplcopy)=='table'
    for file in *project.tplcopy
      ofile=file\gsub '^.+/', ''
      status,err=cpfile file, '', project.oprefix, ofile
      return nil, err unless status
  return true
