require 'rubygems'
require 'commander'

program :name, 'Foo Bar'
program :version, '1.0.0'
program :description, 'Stupid command that prints foo or bar.'

command :foo do |c|
  c.syntax = "foobar foo"
  c.description = "Displays foo"
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