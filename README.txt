
= Commander

Small, intuative gem for creating executables. Commander
bridges the gap between other terminal related libraries
you know and love (OptionParser, HighLine).

== Features:

* Easier than baking cookies
* Parses options using OptionParser
* Auto-populates struct with options ( no more { |v| options[:recursive] = v } )
* Auto-generates help documentation via pluggable help formatters
* Imports the highline gem for interacting with the terminal
* Adds additional user interaction functionality
* Highly customizable progress bar with intuative, simple usage
* Use the 'commander' executable to initialize a commander driven program

== Example:

For more option examples view the Commander::Command#option method. Also
an important feature to note is that when_called may be a class to instantiate,
as well as an object, specifying a method to call, so view the RDoc for more information.

   require 'rubygems'
   require 'commander'

   program :name, 'Foo Bar'
   program :version, '1.0.0'
   program :description, 'Stupid command that prints foo or bar.'

   command :foo do |c|
     c.syntax = "foobar foo"
     c.description = "Display foo"
     c.when_called do |args, options|
       say "foo"
		 end
   end

   command :bar do |c|
     c.syntax = "foobar [options] bar"
     c.description = "Display bar with optional prefix"
     c.option "--prefix STRING"
     c.when_called do |args, options|
       say "#{options.prefix} bar"
     end
   end

== HighLine:

As mentioned above the highline gem is imported into 'global scope', below
are some quick examples for how to utilize highline in your command(s):
   
   # Ask for password masked with '*' character
   ask("Password:  ") { |q| q.echo = "*" }
  
   # Ask for password 
   p ask("Password:  ") { |q| q.echo = false }

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

== HighLine & Interaction Additions:

In addition to highline's fantastic choice of methods we will continue to
simplify common tasks using the following methods:

   # Ask for password 
   password
   
   # Ask for password with specific message and mask character
   password "Enter your password please:", '-'

   # Simple progress bar (Commander::UI::ProgressBar)
   uris = %w[ 
     http://vision-media.ca 
     http://google.com 
     http://yahoo.com
     ]
   progress uris do |uri|
     res = open uri
     # Do something with response
   end

  # 'Log' action to stdout
  log "create", "path/to/file.rb"

== FileUtils:

The VerboseFileUtils module is automatically included within the main object for
global usage. These will output 'log' messages like:

  remove  doc
  create  path
  create  path/to/file.rb
  
If you do not wish to use FileUtils in a verbose manor simply include FileUtils
or call the FileUtil module methods directly.

== Known Issues:
  
* none

== Todo:

* view refactor / clean up stying / remove requiring of deps... just use require
* view RakeFileUtils
* change auto complete key from esc to command + space ?
* Change included FileUtils to VerboseFileUtils... iterate meths and super to module ancestor chain (document disabling by include FileUtils)
* Add ask_for_CLASS where CLASS becomes Date, Time, Array, etc
* Add classify to commander exec
* Add global --options switch for loading options from a filepath
* Add global options... change runner implementations as well as displaying in terminal formatter, OpenStruct inherit these options?
* Add highline page_and_wrap (less)
* Add optional arbitrary help 'blocks' for AUTHOR, etc
* Add optional large_description, short_description, (description, summary|teaser)
* Add program :copyright
* Add spec.opts / spec/rake/spectask ?.. with --color
* Add; dynamically generate padding for help.erb command list
* Fix cause of several Dir#[] calls..
* Use autoload 
* Wrap rescue around app, global --trace option to view stacktrace .. document use Exceptions.. uncaught.. not abort

* Create command-alias branch ...

  drupal module_create MODULE
  drupal module create MODULE
  
  alias_command "module create", :module_create
  alias_command "create module", :module_create, ["--verbose"]
  
  command :create_module do |c|
    c.alias "module create" ....
  end

* Change; conditional wrapping of FileUtils (require 'commander/fileutils')
* Change; convert to echoe / README.rdoc
* Change; format progress bar ETA / elapsed better
* Change; output options in a better format
* Change; refactor rspec with mocks/stubs etc
* Change; reverse |options, args| so args can be |options, file, dir| etc.. adjust doc
* Change; seperate spec suites.. describe with more granularity
* Change; set up regular rake tasks properly... and reformat rspec (view other conventions)
* Fix ERB whitespace.. its being retarted... (use '-' mode?)
* Fix errors raised at_exit are not written to stderr; (try exit after run!)
* Publish help docs


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
