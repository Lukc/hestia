package = "lunadoc"
version = "0.1-1"

source = {
  url = "https://github.com/cuddlyrobot/lunadoc"
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

  -- Build dependency
  "luarocks-addon-moonc"
}

build = {
  type = "command",
  build_command = "moonc .",
  modules = {
    lunadoc = "modules/lunadoc/init.lua"
  }
}
