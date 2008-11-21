
require 'optparse'

module Commander
  class Runner
    
    attr_reader :commands, :options
    
    ##
    # Initialize a new command runner.
    #
    # The command runner essentially manages execution
    # of a commander program. For testing and arbitrary
    # purposes we can specify +input+, +output+, and 
    # +args+ parameters to aid in mock terminal usage etc.
    #
    
    def initialize(input = $stdin, output = $stdout, args = ARGV)
      @input, @output, @args = input, output, args
      @commands, @options = {}, { :help => false }
    end
    
    ##
    # Generate a command object instance using a block
    # evaluated with the command as its scope.
    #
    # === Examples:
    #    
    #    command :my_command do |c|
    #      c.when_called do |args|
    #        # Code
    #      end
    #    end
    #
    # === See:
    #
    # * Commander::Command
    # * Commander::Runner#add_command
    #
    
    def command(name, &block)
      command = Commander::Command.new name
      command.instance_eval &block
      add_command command
    end
    
    ##
    # Add a command object to this runner.
    
    def add_command(command)
      @commands[command.name] = command
    end
    
    ##
    # Get a command object if available or nil.
    
    def get_command(name)
      @commands[name] || nil
    end
    
    ##
    # Get active command within arguments passed to this runner.
    #
    # === Returns:
    #    
    # Commander::Command object or nil
    #
    # === See:
    #
    # * Commander::Runner#parse_global_options
    #
    
    def active_command
      get_command(parse_global_options.shift.to_sym) rescue nil
    end
    
    ##
    # Parse global command options.
    #
    # These options are used by commander itself 
    # as well as allowing your program to specify 
    # global commands such as '--trace'.
    #
    # TODO: allow 'option' method for global program
    #
    # === Returns:
    #    
    # +@args+ duplicate parsed of global options
    #
    
    def parse_global_options
      args = @args.dup
      opts = OptionParser.new
      opts.on("--help") { @options[:help] = true }
      opts.parse! args
    rescue OptionParser::InvalidOption
      # Ignore invalid options since options will be further 
      # parsed by our sub commands.
    ensure 
      args
    end
    
  end
end