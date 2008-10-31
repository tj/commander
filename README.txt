= commander
 
  Open source sub-command framework.

== DESCRIPTION:

  Commander is a small framework for creating a sub-command utility. 
  For example a sub command would be 'git add' or 'git rm', where 'add' and
  'rm' are sub commands.

== FEATURES:

  * Sub-commands
  * Auto-generated help documentation globally and per sub-command
  * Simple syntax and implementation
  * Extensible help generators for various output formats
  
== USAGE:

  require 'commander'
  
  init_commander(
      :name => 'Commander', 
      :version => Commander::VERSION, 
      :description => 'Commander utility program.'
    )
  
  command :init do |c|
  	c.syntax = 'commander init <filepath>'
  	c.description = 'Initialize an empty file with a commander skeleton.'
  	c.example 'Apply commander to a blank file.', 'commander init ./bin/my_executable'
  	c.option('-r', '--recursive', 'Do something recursively') { puts "I am recursive." } 
  	c.option('-v', '--verbose', 'Do something verbosely') { puts "I am verbose." } 
  	c.when_called do |args|
  		 list = ask_for_list "List:"
  		 do_something if confirm "Sure you want to delete?"
  	end
  end

== KNOWN ISSUES:
  
  * none

== TODO:

  * add / test support for sub-command and global options
  * create / save command documentation to /usr/local/commander?
  * support command-line coloring
  * default options --help, --version, --debug, --trace, etc
  * refactor

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

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
