
require 'optparse'

module Commander
  class Runner
    
    #--
    # Exceptions
    #++

    class CommandError < StandardError; end
    class InvalidCommandError < CommandError; end
    
    attr_reader :commands, :options
    
    ##
    # Initialize a new command runner.
    #
    # The command runner essentially manages execution
    # of a commander program. For testing and arbitrary
    # purposes we can specify _input_, _output_, and 
    # _args_ parameters to aid in mock terminal usage etc.
    #
    
    def initialize input = $stdin, output = $stdout, args = ARGV
      @input, @output, @args = input, output, args
      @commands, @options = {}, { :help => false, :version => false }
      @program = { :help_formatter => Commander::HelpFormatter::Terminal }
      create_default_commands
      parse_global_options
    end
    
    ##
    # Run the command parsing and execution process immediately.
    
    def run!
      %w[ name version description ].each { |k| ensure_program_key_set k.to_sym }
      case 
      when options[:version] : @output.puts "#{@program[:name]} #{@program[:version]}" 
      when options[:help] : get_command(:help).run
      else active_command.run args_without_command
      end
    rescue InvalidCommandError
      @output.puts "invalid command. Use --help for more information"
    rescue OptionParser::InvalidOption, 
      OptionParser::InvalidArgument,
      OptionParser::MissingArgument => e
      @output.puts e 
    end
    
    ##
    # Assign program information.
    #
    # === Examples:
    #    
    #    # Set data
    #    program :name, 'Commander'
    #    program :version, Commander::VERSION
    #    program :description, 'Commander utility program.'
    #    program :help, 'Copyright', '2008 TJ Holowaychuk'
    #    program :help, 'Anything', 'You want'
    #
    #    # Get data
    #    program :name # => 'Commander'
    #
    # === Keys:
    #
    #    :name            (required) Program name
    #    :version         (required) Program version triple, ex: '0.0.1'
    #    :description     (required) Program description
    #    :help_formatter  Defaults to Commander::HelpFormatter::Terminal
    #    :help            Allows addition of arbitrary global help blocks
    #
    
    def program key, *args
      if key == :help and !args.empty?
        @program[:help] ||= {}
        @program[:help][args.first] = args[1]
      else
        @program[key] = *args unless args.empty?
        @program[key] if args.empty?
      end
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
    
    def command name, &block
      command = Commander::Command.new(name) and yield command
      add_command command
    end
    
    ##
    # Add a command object to this runner.
    
    def add_command command
      @commands[command.name] = command
    end
    
    ##
    # Get a command object if available or nil.
    
    def get_command name
      if @commands[name] 
        @commands[name]
      else
        raise InvalidCommandError, "Invalid command '#{name || "nil"}'", caller
      end
    end
    
    ##
    # Get active command within arguments passed to this runner.
    #
    # === See:
    #
    # * Commander::Runner#parse_global_options
    #
    
    def active_command
      get_command command_name_from_args
    end
    
    ##
    # Attemps to locate command from @args, otherwise nil.
    
    def command_name_from_args 
      @args.find { |arg| arg.match /^[a-z_0-9]+$/i }.to_sym rescue nil
    end
    
    ##
    # Help formatter instance.
    
    def help_formatter
      @_help_formatter ||= @program[:help_formatter].new self
    end
        
    private
    
    ##
    # Creates default commands such as 'help' which is 
    # essentially the same as using the --help switch.
    
    def create_default_commands
      command :help do |c|
        c.syntax = "command help <sub_command>"
        c.description = "Displays global or sub-command help information"
        c.example "Display global help", "command help"
        c.example "Display help for 'foo'", "command help foo"
        c.when_called do |args, options|
          gen = help_formatter
          if args.empty?
            @output.puts gen.render 
          else
            @output.puts gen.render_command(get_command(args.shift.to_sym))
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
    #
    # TODO: allow 'option' method for global program
    #
    
    def parse_global_options
      opts = OptionParser.new
      opts.on("--help") { @options[:help] = true }
      opts.on("--version") { @options[:version] = true }
      opts.parse! @args.dup
    rescue OptionParser::InvalidOption
      # Ignore invalid options since options will be further 
      # parsed by our sub commands.
    end
        
    def ensure_program_key_set key #:nodoc:
      raise CommandError, "Program #{key} required (use #program method)" if (@program[key].nil? || @program[key].empty?)
    end
    
    def args_without_command #:nodoc: 
      @_args_without_command ||= @args.dup.delete_first_match(active_command.name.to_s) 
    end
        
  end
end