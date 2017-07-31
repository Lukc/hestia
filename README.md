![lunadoc logo](./logo.png)

A better documentation generator for Moonscript

## Installation

### from git

* Run `./setup.zsh`.
* add the project folder to your `PATH` or symlink `lunadoc` into it.

### using luarocks

`luarocks install lunadoc` (thanks to ❤[spacekookie](https://github.com/spacekookie))

## Usage

Comment your code (in `.moon` files, obviously) like so:

```moonscript
--- First line of comment block
-- second line
-- ....
class Something
```

Markdown is enabled while parsing those comments, and you can just use links to anchors/other files to reference stuff.

Note, to make a paragraph you have to include it as a properly prefixed `-- ` line (that's "dash-dash-space"!).

Comment based Documentation is currently supported for:

* `class ...`
  - `extends ...`
  - `...: ...` static properties
  - `...: (...)->` static methods
  - `...: (...)=>` dynamic methods
* `...= (...)->` functions
* `...= (...)=>` pseudo dynamic functions

Also, `.md` files will be handled as plain markdown and converted to html.

The markdown parser is [discount](https://github.com/craigbarnes/lua-discount).

Add a file `lunadoc.cfg` to your project:

```moonscript
title: 'The name of your project'
iprefix: 'prefix/to/input/files/'
oprefix: 'prefix/to/doc/files/'
files: {
  'some_file.moon'
  'some_folder/some_file.moon'
  'some_file.md'
  copy: { -- table of files to plainly copy, omit if unused
    'some_file'
  }
}
author: 'You' -- omit if you don't want a copyright notice in the docs
date: 'when' -- omit if you don't want a copyright notice in the docs
tpl: require 'your.custom.template' -- to load an etlua template for the html, or just omit it to use our default
tplcopy: { -- table of absolute paths to copy to the oprefix (without subdirectories), omit to use the defaults (syntax highlighting using highlight.js)
  find_css 'your.custom.css' -- helper that finds .css file in module paths
  find_js 'your.custom.js' -- helper that finds .js file in module paths
}
discount: { -- flags for discount, omit to use the default flags shown here
  'toc'
  'extrafootnote'
  'dlextra'
  'fencedcode'
}
```

then run `lunadoc`.

---

[![forthebadge](http://forthebadge.com/images/badges/built-by-codebabes.svg)](http://forthebadge.com)
[![forthebadge](http://forthebadge.com/images/badges/you-didnt-ask-for-this.svg)](http://forthebadge.com)
[![forthebadge](http://forthebadge.com/images/badges/fuck-it-ship-it.svg)](http://forthebadge.com)
[![forthebadge](http://forthebadge.com/images/badges/kinda-sfw.svg)](http://forthebadge.com)
