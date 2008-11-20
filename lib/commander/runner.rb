
require 'optparse'

module Commander
  class Runner
    
    attr_reader :commands
    
    def initialize(input = $stdin, output = $stdout, args = ARGV)
      @input, @output, @args = input, output, args
      @commands = {}
    end
    
    def command(name, &block)
      command = Commander::Command.new name
      command.instance_eval &block
      @commands[name] = command
    end
    
    def get_command(name)
      @commands[name] || nil
    end
    
    def active_command(args = @args)
      # TODO: global options
    end
    
  end
end