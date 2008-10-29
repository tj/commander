= commander
 
  Open source sub-command framework.

== DESCRIPTION:

  Commander is a small framework for creating a sub-command utility. 
  For example a sub command would be 'git add' or 'git rm', where 'add' and
  'rm' are sub commands.

== FEATURES:

  * Sub commands
  * Auto-generated help documentation
  * Simple syntax and implementation
  * Extensible help generators for various output formats

== KNOWN ISSUES:
  
  * none

== TODO:

  * Use own option parser... or extend OptionParser to pull values
  * OpenStruct so that c.options can be stored for .when_called
  * default options --help, --version, --debug, --trace, etc
  * default arg help COMMAND, equiv to COMMAND --help?
  * allow subcommands like 'drupal create module' instead of 'drupal create_module'
  * allow copyright info
  * allow help with commander_init :help_generator => Commander::HelpGenerator::Default
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
