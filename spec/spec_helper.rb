
require 'commander'
require 'stringio'

def create_test_command
  command :test do |c|
    c.syntax = "test [options] <file>"
    c.description = "test description"
    c.example "description", "command"
    c.example "description 2", "command 2"
    c.option "-t", "--trace", "trace description"
    c.option "--verbose", "verbose description"
    c.when_called do |args, options|
      "test %s" % args.join
    end
  end
end

def new_command_runner *args
  $command_runner = Commander::Runner.new args
  program :name, "test"
  program :version, "1.2.3"
  program :description, "something"
  create_test_command
end