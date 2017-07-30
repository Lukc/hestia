gsplit=require'lunadoc.gsplit'
(str,by)-> table.concat [by..line for line in gsplit str,'\n',true], '\n'
