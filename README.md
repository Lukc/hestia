
Experimental documentation generator for Moonscript.

# Installation

## from git

* Run `make LUA_VERSION=5.3 PREFIX=/usr install` or `make help`.

# Usage

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

Add a file `lunradoc.cfg` to your project:

```moonscript
title: 'The name of your project'
iprefix: 'prefix/to/input/files/'
outputDirectory: 'prefix/to/doc/files/'
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
hljsstyle: 'monokai-sublime' -- specific to the default template: the style sheet to use for highlight.js
templateFiles: { -- table of absolute paths to copy to the oprefix (without subdirectories), omit to use the defaults (syntax highlighting using highlight.js)
  find_css 'your.custom.css' -- helper that finds .css file in module paths
  find_js 'your.custom.js' -- helper that finds .js file in module paths
}
modulefilter: (str)-> str -- a filter function to use on module names, omit if not required
discountFlags: { -- flags for discount, omit to use the default flags shown here
  'toc'
  'extrafootnote'
  'dlextra'
  'fencedcode'
}
```

then run `lunradoc`.

