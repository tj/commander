require 'rubygems'
require 'commander'

# :name is optional, otherwise uses the basename of this executable
program :name, 'Foo Bar'
program :version, '1.0.0'
program :description, 'Stupid command that prints foo or bar.'

command :foo do |c|
  c.syntax = 'foobar foo'
  c.description = 'Displays foo'
  c.when_called do |args, options|
    say 'foo'
  end
end

command :bar do |c|
  c.syntax = 'foobar bar [options]'
  c.description = 'Display bar with optional prefix and suffix'
  c.option '--prefix STRING', String, 'Adds a prefix to bar'
  c.option '--suffix STRING', String, 'Adds a suffix to bar'
  c.when_called do |args, options|
    options.default :prefix => '(', :suffix => ')'
    say "#{options.prefix}bar#{options.suffix}"
  end
end

$ foobar bar
# => (bar)

$ foobar bar --suffix '{' --prefix '}'
# => {bar}