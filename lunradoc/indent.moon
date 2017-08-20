gsplit=require'lunradoc.gsplit'
(str,by)-> table.concat [by..line for line in gsplit str,'\n',true], '\n'
