
= Commander

Small, intuative gem for creating executables. Commander is generally used
for sub-command driven programs, although support for unary executables do
and will continue to be supported. 

== Example:

   require 'rubygems'
   require 'commander'

   program :name, 'Foo Bar'
   program :version, '1.0.0'
   program :description, 'Stupid command that prints foo or bar.'

   command :foo do |c|
     c.syntax = "foobar [options] foo"
     c.description = "Display foo"
     c.when_called do |args|
       say 'foo'
     end
   end

   command :bar do |c|
   ...

== Features:

* Easier than baking cookies
* Parses options using OptionParser
* Imports the highline gem for interacting with the terminal
* Auto-generates help documentation via pluggable help formatters
* Adds additional user interaction functionality

== Known Issues:
  
* none

== Todo:

* redo README
* README.rdoc
* auto run! at_exit
* fix ERB whitespace... -%> ??
* enforce command description and syntax or make optional in ERB
* coloring via highline
* allow options to take a block OR populate a struct.. passed with |args, options| ?
* help generator options (such as large option description etc)
* help generators should use erb
* refactor rspec with mocks etc
* increase support for programs without sub-commands
* clean up documentation, tm conventions

== LICENSE:

(The MIT License)

Copyright (c) 2008 TJ Holowaychuk <tj@vision-media.ca>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
