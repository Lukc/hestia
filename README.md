
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
  - `...: ...` static properties
  - `...: (...) ->` static methods
  - `...: (...) =>` dynamic methods
* `{ ... }` modules

Only the returned value of a module can be documented at the moment and any local value will remain hidden.

Also, `.md` files will be handled as plain markdown and converted to html.

The markdown parser is [discount](https://github.com/craigbarnes/lua-discount).

Add a file `lunradoc.cfg` to your project:

```moonscript
title: 'The name of your project'
inputPrefix: 'prefix/to/input/files/'
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
template: require 'your.custom.template' -- to load an etlua template for the html, or just omit it to use our default

modulefilter: (str)-> str -- a filter function to use on module names, omit if not required
discountFlags: { -- flags for discount, omit to use the default flags shown here
  'toc'
  'extrafootnote'
  'dlextra'
  'fencedcode'
}
```

then run `lunradoc`.

