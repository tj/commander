require 'rubygems'
require 'stringio'
require 'simplecov'
SimpleCov.start

# Unshift so that local files load instead of something in gems
$:.unshift File.dirname(__FILE__) + '/../lib'

# This basically replicates the behavior of `require 'commander/import'`
# but without adding an `at_exit` hook, which interferes with exit code
require 'commander'
require 'commander/delegates'

include Commander::UI
include Commander::UI::AskForClass
include Commander::Delegates

# prevent paging from actually occurring in test environment

module Commander
  module UI
    def enable_paging
      return
    end
  end
end

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

# Create a new command runner

def new_command_runner *args, &block
  Commander::Runner.instance_variable_set :"@singleton", Commander::Runner.new(args)
  program :name, 'test'
  program :version, '1.2.3'
  program :description, 'something'
  create_test_command
  yield if block
  Commander::Runner.instance
end

# Comply with how specs were previously written

def command_runner
  Commander::Runner.instance
end

def run *args
  new_command_runner(*args) do
    program :help_formatter, Commander::HelpFormatter::Base
  end.run!    
  @output.string
end