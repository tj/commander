
require 'optparse'

module Commander
  class Runner
    
    class Error < StandardError; end
    class InvalidCommandError < Error; end
    
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
      parse_global_options
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
      if @commands[name] 
        @commands[name]
      else
        raise InvalidCommandError, "Invalid command '#{name || "nil"}'", caller
      end
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
      # TODO: re-raise any runner errors
      get_command command_name_from_args
    end
    
    ##
    # Attemps to locate command from @args, otherwise nil.
    
    def command_name_from_args 
      @args.find { |arg| arg.match /^[a-z_0-9]+$/i }.to_sym rescue nil
    end
    
    ##
    # Parse global command options.
    #
    # These options are used by commander itself 
    # as well as allowing your program to specify 
    # global commands such as '--verbose'.
    #
    # TODO: allow 'option' method for global program
    #
    
    def parse_global_options
      opts = OptionParser.new
      opts.on("--help") { @options[:help] = true }
      opts.parse! @args.dup
    rescue OptionParser::InvalidOption
      # Ignore invalid options since options will be further 
      # parsed by our sub commands.
    end
    
  end
end