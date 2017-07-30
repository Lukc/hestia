A better documentation generator for Moonscript

## Installation

* Run `./setup.zsh`.
* add the project folder to your `PATH` or symlink `lunadoc` into it.

## Usage

Comment your code (in `.moon` files, obviously) like so:

    --- First line of comment block
    -- second line
    -- ....
    class Something

Markdown is enabled while parsing those comments, and you can just use links to anchors/other files to reference stuff.

Note, to make a paragraph you have to include it as a properly prefixed `-- ` line (that's "dash-dash-space"!).

Comment based Documentation is currently supported for:

* `class`
  - `extends`
  - `...: ...` properties
  - `...: (...)->` static methods
  - `...: (...)=>` dynamic methods
* `...= (...)->` functions
* `...= (...)=>` pseudo dynamic functions

Also, `.md` files will be handled as plain markdown and converted to html.

Add a file `lunadoc.cfg` to your project:

    {
      title: 'The name of your project'
      iprefix: 'prefix/to/input/files/' -- note to set this to '' (empty string) if you don't want a prefix instead of omitting it (nil) or things will crash
      oprefix: 'prefix/to/doc/files/'
      files: {
        'some_file.moon'
        'some_folder/some_file.moon'
        'some_file.md'
      }
      author: 'You'
      date: 'when'
    }

then run `lunadoc`.

---

[![forthebadge](http://forthebadge.com/images/badges/built-by-codebabes.svg)](http://forthebadge.com)
[![forthebadge](http://forthebadge.com/images/badges/you-didnt-ask-for-this.svg)](http://forthebadge.com)
[![forthebadge](http://forthebadge.com/images/badges/fuck-it-ship-it.svg)](http://forthebadge.com)
[![forthebadge](http://forthebadge.com/images/badges/kinda-sfw.svg)](http://forthebadge.com)
