
require 'optparse'

module Commander
  class Runner
    
    #--
    # Exceptions
    #++

    class CommandError < StandardError; end
    class InvalidCommandError < CommandError; end
    
    ##
    # Commands within the runner.
    
    attr_reader :commands
    
    ##
    # Global options.
    
    attr_reader :options
    
    ##
    # Initialize a new command runner. Optionally
    # supplying +args+ for mocking, or arbitrary usage.
    
    def initialize args = ARGV
      @args, @commands, @options = args, {}, {}
      @program = program_defaults
      create_default_commands
      parse_global_options
    end
    
    ##
    # Run command parsing and execution process.
    
    def run!
      require_program :name, :version, :description
      case 
      when options[:version] ; $terminal.say "#{program(:name)} #{program(:version)}" 
      when options[:help]    ; command(:help).run(*@args[1..-1])
      else                     active_command.run *args_without_command_name
      end
    rescue InvalidCommandError
      $terminal.say 'invalid command. Use --help for more information'
    rescue \
      OptionParser::InvalidOption, 
      OptionParser::InvalidArgument,
      OptionParser::MissingArgument => e
      $terminal.say e
    end
    
    ##
    # Assign program information.
    #
    # === Examples:
    #    
    #   # Set data
    #   program :name, 'Commander'
    #   program :version, Commander::VERSION
    #   program :description, 'Commander utility program.'
    #   program :help, 'Copyright', '2008 TJ Holowaychuk'
    #   program :help, 'Anything', 'You want'
    #   program :int_message 'Bye bye!'
    #   
    #   # Get data
    #   program :name # => 'Commander'
    #
    # === Keys:
    #
    #   :name            (required) Program name
    #   :version         (required) Program version triple, ex: '0.0.1'
    #   :description     (required) Program description
    #   :help_formatter  Defaults to Commander::HelpFormatter::Terminal
    #   :help            Allows addition of arbitrary global help blocks
    #   :int_message     Message to display when interrupted (CTRL + C)
    #
    
    def program key, *args
      if key == :help and !args.empty?
        @program[:help] ||= {}
        @program[:help][args.first] = args[1]
      else
        @program[key] = *args unless args.empty?
        @program[key]
      end
    end
    
    ##
    # Creates and yields a command instance when a block is passed.
    # Otherise attempts to return the command, raising InvalidCommandError when
    # it does not exist.
    #
    # === Examples:
    #    
    #   command :my_command do |c|
    #     c.when_called do |args|
    #       # Code
    #     end
    #   end
    #
    
    def command name, &block
      yield add_command(Commander::Command.new(name)) if block
      @commands[name.to_s] or raise InvalidCommandError, "invalid command '#{ name || 'nil' }'", caller
    end
    
    ##
    # Alias command +name+ with +alias_name+.
    
    def alias_command alias_name, name
      @commands[alias_name.to_s] = command name
    end
    
    ##
    # Add a command object to this runner.
    
    def add_command command
      @commands[command.name] = command
    end
    
    ##
    # Check if a command +name+ exists.
    
    def command_exists? name
      @commands[name.to_s]
    end
    
    ##
    # Get active command within arguments passed to this runner.
    
    def active_command
      @__active_command ||= command(command_name_from_args)
    end
    
    ##
    # Attemps to locate a command name from within the arguments.
    # Supports multi-word commands, using the largest possible match.
    
    def command_name_from_args
      @__command_name_from_args ||= valid_command_names_from(*@args.dup).sort.last
    end
    
    ##
    # Returns array of valid command names found within +args+.
    
    def valid_command_names_from *args
      arg_string = args.delete_switches.join ' '
      commands.keys.find_all { |name| name if /^#{name}/.match arg_string }
    end
    
    ##
    # Help formatter instance.
    
    def help_formatter
      @__help_formatter ||= program(:help_formatter).new self
    end
    
    ##
    # Return arguments without the command name.
    
    def args_without_command_name
      removed = []
      parts = command_name_from_args.split
      @args.dup.delete_if do |arg|
        removed << arg if parts.include?(arg) and not removed.include?(arg)
      end
    end
            
    private
    
    ##
    # Returns hash of program defaults.
    
    def program_defaults
      return :help_formatter => HelpFormatter::Terminal, :int_message => "\nProcess interrupted"
    end
    
    ##
    # Creates default commands such as 'help' which is 
    # essentially the same as using the --help switch.
    
    def create_default_commands
      command :help do |c|
        c.syntax = 'command help <sub_command>'
        c.summary = 'Display help documentation for <sub_command>'
        c.description = 'Display help documentation for the global or sub commands'
        c.example 'Display global help', 'command help'
        c.example "Display help for 'foo'", 'command help foo'
        c.when_called do |args, options|
          if args.empty?
            $terminal.say help_formatter.render 
          else
            $terminal.say help_formatter.render_command(command(args.join(' ')))
          end
        end
      end
    end
            
    ##
    # Parse global command options.
    #
    # These options are used by commander itself 
    # as well as allowing your program to specify 
    # global commands such as '--verbose'.
    
    def parse_global_options
      opts = OptionParser.new
      opts.on('--help') { @options[:help] = true }
      opts.on('--version') { @options[:version] = true }
      opts.parse! @args.dup
    rescue OptionParser::InvalidOption
      # Ignore invalid options since options will be further 
      # parsed by our sub commands.
    end
    
    ##
    # Raises a CommandError when the program any of the +keys+ are not present, or empty.
        
    def require_program *keys
      keys.each do |key|
        raise CommandError, "program #{key} required" if program(key).nil? or program(key).empty?
      end
    end
    
  end
end