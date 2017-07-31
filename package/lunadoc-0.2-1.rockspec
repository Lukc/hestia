package = "lunadoc"
version = "0.2-1"

source = {
  url = "git://github.com/cuddlyrobot/lunadoc.git",
  tag = "0.2"
}

description = {
  summary = "A better documentation generator for Moonscript",
  detailed = [[
     Generate documentation for your Moonscript projects.
  ]],
  homepage = "http://github.com/cuddlyrobot/lunadoc",
  license = "MIT/X11"
}

dependencies = {
  "lua ~> 5.1",
  "discount",
  "moonscript",
  "etlua",
  "loadkit",
  "luafilesystem",
}

build = {
  type = "command",
  build_command = "moonc .",
  modules = {
    ["lunadoc.init"] = "modules/lunadoc/init.lua",
    ["lunadoc.indent"] = "modules/lunadoc/indent.lua",
    ["lunadoc.gsplit"] = "modules/lunadoc/gsplit.lua",
    ["lunadoc.doc_moon"] = "modules/lunadoc/doc_moon.lua"
  },

  install = { 
    bin = { "lunadoc" },
    lua = {
      ["lunadoc.init"] = "modules/lunadoc/init.lua",
      ["lunadoc.indent"] = "modules/lunadoc/indent.lua",
      ["lunadoc.gsplit"] = "modules/lunadoc/gsplit.lua",
      ["lunadoc.doc_moon"] = "modules/lunadoc/doc_moon.lua",
      ["lunadoc.templates.hljs"] = "modules/lunadoc/templates/hljs.js",
      ["lunadoc.templates.html"] = "modules/lunadoc/templates/html.elua",
      ["lunadoc.templates.style"] = "modules/lunadoc/templates/style.css",
      ["lunadoc.templates.hlstyles.monokai"] = "modules/lunadoc/templates/monokai.css"
    }
  }
}
