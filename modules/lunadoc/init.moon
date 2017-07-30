import register,make_loader from require 'loadkit'
import compile from require'discount'
import mkdir from require'lfs'
moonscript = require'moonscript.base'
doc_moon=require 'lunadoc.doc_moon'
indent=require'lunadoc.indent'

register 'elua', (file)->
  assert require'etlua'.compile file\read'*a'

loadcfg=(file)->
  (assert moonscript.loadstring '{\n' .. indent(file\read'*a', '  ') .. '\n}')!

cfgloader=make_loader 'cfg', loadcfg, './?.lua'

project=cfgloader 'lunadoc'

project.iprefix or= ''
project.oprefix or= ''

tpl=project.tpl or require 'lunadoc.templates.html'

discountflags=project.discount or {'toc', 'extrafootnote', 'dlextra', 'fencedcode'}

mkdirp=(path)->
  ppath=path\match '^(.+)/[^/]+'
  if ppath
    mkdirp ppath
  mkdir path

for file in *project.files
  document = switch file\match '^.+%.(.+)$'
    when 'moon' then assert compile(assert(doc_moon assert(io.open project.iprefix .. file)\read'*a'), unpack discountflags)
    when 'md' then assert compile(assert(io.open project.iprefix .. file)\read('*a'), unpack discountflags)
  document.file = file
  document.project = project
  document.title or= file\gsub('%.[^%.]+$','')\gsub('/','.')
  document.date or= project.date
  document.author or= project.author
  dir=(project.oprefix..file)\match '^(.+)/[^/]+'
  mkdirp dir if dir
  with assert io.open project.oprefix..file\gsub('%.[^%.]+$','.html'), 'w'
    \write tpl document
    \close!
