
require 'optparse'

module Commander
  class Command
    
    attr_reader :name, :examples, :options, :when_called_proc
    attr_accessor :syntax, :description
        
    ##
    # Initialize new command with specified +name+.
    
    def initialize(name)
      @name, @examples, @options = name, [], []
    end
    
    ##
    # Add a usage example for this command.
    #
    # Usage examples are later displayed in help documentation
    # created by the help formatters.
    #
    # === Examples:
    #    
    #    command :something do |c|
    #      c.example "Should do something", "ruby my_command something"
    #    end
    #
    
    def example(description, code)
      @examples << {
        :description => description,
        :code => code,
      }
    end
    
    ##
    # Add an option.
    #
    # Options are parsed via OptionParser so view it
    # for additional usage documentation.
    #
    # === Examples:
    #    
    #    command :something do |c|
    #      options = { :recursive => false }
    #      c.option('--recursive') { options[:recursive] => true }
    #
    #      c.when_called do |args|
    #        do_something_recursively if options[:recursive]
    #      end 
    #    end
    #
    
    def option(*args, &block)
      @options << {
        :args => args,
        :proc => block,
      }
    end
    
    ##
    # Handle execution of command.
    #
    # This is the only method required for a sub command
    # to function properly, as it is called when a user
    # invokes the sub command via the command-line.
    #
    # An array of +args+ are passed to the block.
    #
    # === Examples:
    #    
    #    command :something do |c|
    #      c.when_called do |args|
    #        # do something
    #      end 
    #    end
    #
    
    def when_called(&block)
      @when_called_proc = block
    end
    
    ##
    # Run the command with +args+.
    #
    # * parses options, call option blocks
    # * invokes when_called proc
    #
    
    def run(args = [])
      call parse_options_and_call_procs(args)
    end
    
    ##
    # Parses options and calls associated procs
    # returning the arguments left.
    
    def parse_options_and_call_procs(args = [])
      return args if args.empty?
      opts = OptionParser.new
      @options.each { |o| opts.on(*o[:args], &o[:proc]) }
      opts.parse! args
      args
    end
    
    ##
    # Call the commands when_called block with +args+.
    
    def call(*args)
      @when_called_proc.call(*args)
    end
  end
end