parse=require'moonscript.parse'
import pos_to_line,trim,get_line from require 'moonscript.util'
indent=require'lunadoc.indent'

findPreCommentBegin=(code,line)->
  if line <=0
    return nil,'not found'
  sline=get_line code, line
  if sline
    sline=trim(sline..'#')\sub(1,-2)
    if sline\sub(1,4)=='--- '
      return line
    if sline\sub(1,3)!='-- '
      return nil,'broken block'
  return findPreCommentBegin code, line-1

getPreCommentForLine=(code,line)->
  endline=line-1
  startline,err=findPreCommentBegin code, endline
  if startline==nil
    return nil, err
  return table.concat [(trim get_line code, l)\sub l==startline and 5 or 4 for l=startline,endline], '\n'
  

walkAST_addcomments=(code,ast)->
  for k,v in pairs ast
    if type(v)=='table'
      if type(v[-1])=='number'
        v[-2]=pos_to_line code, v[-1]
        v[-3]=getPreCommentForLine code, v[-2] if v[-2]
      walkAST_addcomments code, v

deref=(tbl,maystring)->
  return tbl if type(tbl)=='string' and maystring
  return nil if type(tbl)!='table'
  switch tbl[1]
    when 'ref'
      tbl[2]
    when 'string'
      tbl[2]..tbl[3]..tbl[2]
    when 'number'
      tbl[2]
    when 'dot'
      '.'..tbl[2]
    when 'call'
      '('..table.concat([deref i for i in *tbl[2]],',')..')'
    when 'chain'
      table.concat [deref tbl[i] for i=2,#tbl],''
    when 'fndef'
      args={}
      for v in *tbl[2]
        name=deref v[1],true
        default=deref v[2]
        table.insert args, name..(default and '='..default or '')
      (#args>0 and '('..table.concat(args,',')..')' or '')..(tbl[4]=='fat' and '=>' or '->')
    when 'self'
      '@'..tbl[2]

walkAST_extractMD_props=(ast,head,methods)->
  to=''
  for k,v in pairs ast
    if type(v)=='table' and v[1]=='props'
      if (v[2][2][1]=='fndef' and methods) or (v[2][2][1]!='fndef' and not methods)
        to ..= head..'# `'
        switch v[2][1][1]
          when 'key_literal'
            to ..= v[2][1][2] ..': '
        to ..= deref v[2][2]
        to ..= '`\n'
        if v[2][2][-3]
          to ..= indent v[2][2][-3], '  '
          to ..= '\n'
  if to!=''
    return head..(methods and ' Methods\n' or ' Properties\n')..to..'\n'
  return to

walkAST_extractMD=(ast,to='',head='#')->
  for k,v in pairs ast
    if type(v)=='table'
      switch v[1]
        when 'class'
          if v[-3]
            to ..= '----\n'
            to ..= head..' `class '..v[2]..'`'
            if type(v[3])=='table'
              to ..= '\n'..head..'# `extends '..deref(v[3])..'`\n'
            to ..= '\n' .. v[-3] .. '\n\n'
            to ..= walkAST_extractMD_props v[4], head..'#',false
            to ..= walkAST_extractMD_props v[4], head..'#',true
        when 'assign'
          if v[3][1][1]=='fndef' and v[2][1][-3]
            to ..= '----\n'
            to ..= head..' `'..deref(v[2][1])
            to ..= deref v[3][1]
            to ..= '`\n' .. v[2][1][-3] .. '\n\n'
        else
          walkAST_extractMD v,to,head
  return to


(code)->
  ast=parse.string code
  walkAST_addcomments code, ast
  --require'moon'.p ast
  --os.exit!
  walkAST_extractMD(ast)
