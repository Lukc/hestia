import register from require 'loadkit'
import compile from require'discount'
import mkdir from require'lfs'
moonscript = require'moonscript.base'

doc_moon=require 'lunadoc.doc_moon'

register "elua", (file)->
  assert require'etlua'.compile file\read'*a'

tpl={
  doc_moon: require 'lunadoc.templates.doc_moon'
}

cfg=moonscript.loadfile 'lunadoc.cfg'

project=cfg!

mkdirp=(path)->
  ppath=path\match '^(.+)/[^/]+'
  if ppath
    mkdirp ppath
  mkdir path

for file in *project.files
  document = switch file\match '^.+%.(.+)$'
    when 'moon' then assert compile assert doc_moon assert(io.open project.iprefix .. file)\read'*a'
    when 'md' then assert compile assert(io.open project.iprefix .. file)\read'*a'
  document.file = file
  document.project = project
  document.title or= file\gsub('%.[^%.]+$','')\gsub('/','.')
  document.date or= project.date
  document.author or= project.author
  dir=(project.oprefix..file)\match '^(.+)/[^/]+'
  mkdirp dir if dir
  with assert io.open project.oprefix..file\gsub('%.[^%.]+$','.html'), 'w'
    \write tpl.doc_moon document
    \close!
