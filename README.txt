
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

== Highline:

As mentioned above the highline gem is imported into 'global scope', below
are some quick examples for how to utilize highline in your command(s):
   
   # As for password masked with '*' character
   ask("Enter your password:  ") { |q| q.echo = "*" }
  
   # Ask for password 
   p ask("Enter your password:  ") { |q| q.echo = false }

   # Ask if the user agrees (yes or no)
   agree("Do something?")

   # Asks on a single line (note the space after ':'
   ask("Name: ")

   # Asks with new line after "Description:"
   ask("Description:")

   # Calls Date#parse to parse the date string passed
   ask("Birthday? ", Date)

   # Ensures Integer is within the range specified
   ask("Age? ", Integer) { |q| q.in = 0..105 }

   # Asks for a list of strings, converts to array
   ask("Fav colors?", Array)

   # Provide a menu for users to choose from
   choose do |menu|
     menu.index = :letter
     menu.index_suffix = ") "
     menu.prompt = "Please choose your favorite programming language?  "
     menu.choice :ruby do say("Good choice!") end
     menu.choices(:python, :perl) do say("Not from around here, are you?") end
   end
   
   # Custom shell
   loop do
     choose do |menu|
       menu.layout = :menu_only
       menu.shell = true
       menu.choice(:load, "Load a file.") do |command, details|
         say("Loading file with options:  #{details}...")
       end
       menu.choice(:save, "Save a file.") do |command, details|
         say("Saving file with options:  #{details}...")
       end
       menu.choice(:quit, "Exit program.") { exit }
     end
   end

== Known Issues:
  
* none

== Todo:

* auto run! at_exit
* highline quick examples / additional user interaction methods
* proxy highline output to clean things up? left justify looks gross..
* add command machine-name to help docs
* global --version switch
* less (highline page_and_wrap)
* increase support for programs without sub-commands
* allow options to take a block OR populate a struct.. passed with |args, options| ?

* fix ERB whitespace.. its being retarted...
* set up regular rake tasks properly... and reformat rspec (view other conventions)
* refactor rspec with mocks etc
* clean up documentation, tm convention
* convert to echoe / README.rdoc
* public help docs

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
