import register from require 'loadkit'
import compile from require'discount'
import mkdir from require'lfs'
moonscript = require'moonscript.base'

html=require 'lunadoc.html'

register "elua", (file)->
  assert require'etlua'.compile file\read'*a'

tpl={
  html: require 'lunadoc.templates.html'
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
    when 'moon' then assert compile(assert(html assert(io.open project.iprefix .. file)\read'*a'), 'toc', 'extrafootnote', 'dlextra', 'fencedcode')
    when 'md' then assert compile(assert(io.open project.iprefix .. file)\read('*a'), 'toc', 'extrafootnote', 'dlextra', 'fencedcode')
  document.file = file
  document.project = project
  document.title or= file\gsub('%.[^%.]+$','')\gsub('/','.')
  document.date or= project.date
  document.author or= project.author
  dir=(project.oprefix..file)\match '^(.+)/[^/]+'
  mkdirp dir if dir
  with assert io.open project.oprefix..file\gsub('%.[^%.]+$','.html'), 'w'
    \write tpl.html document
    \close!
