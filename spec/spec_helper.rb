
require 'rubygems'
require 'commander/import'
require 'stringio'

# Mock terminal IO streams so we can spec against them

def mock_terminal
  @input = StringIO.new
  @output = StringIO.new
  $terminal = HighLine.new @input, @output
end

# Create test command for usage within several specs

def create_test_command
  command :test do |c|
    c.syntax = "test [options] <file>"
    c.description = "test description"
    c.example "description", "command"
    c.example "description 2", "command 2"
    c.option '-v', "--verbose", "verbose description"
    c.when_called do |args, options|
      "test %s" % args.join
    end
  end
  @command = command :test
end

# Create a new global command runner

def new_command_runner *args, &block
  $command_runner = Commander::Runner.new args
  program :name, 'test'
  program :version, '1.2.3'
  program :description, 'something'
  create_test_command
  yield if block
  command_runner
end

def run *args
  new_command_runner *args do
    program :help_formatter, Commander::HelpFormatter::Base
  end.run!    
  @output.string
end