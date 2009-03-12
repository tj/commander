
require 'optparse'
require 'ostruct'

module Commander
  class Command
    
    attr_reader :name, :examples, :options, :proxy_options
    attr_accessor :syntax, :description, :summary
    
    ##
    # Options struct.
    
    class Options < OpenStruct
      def default defaults = {}
        defaults.each do |key, value|
          send "#{key}=", value if send(key).nil?
        end
      end
    end
        
    ##
    # Initialize new command with specified +name+.
    
    def initialize name
      @name, @examples, @when_called = name.to_s, [], []
      @options, @proxy_options = [], []
    end
    
    ##
    # Add a usage example for this command.
    #
    # Usage examples are later displayed in help documentation
    # created by the help formatters.
    #
    # === Examples:
    #    
    #   command :something do |c|
    #     c.example "Should do something", "my_command something"
    #   end
    #
    
    def example description, command 
      @examples.push description, command
    end
    
    ##
    # Add an option.
    #
    # Options are parsed via OptionParser so view it
    # for additional usage documentation. A block may optionally be
    # passed to handle the option, otherwise the _options_ struct seen below 
    # contains the results of this option. This handles common formats such as:
    #
    #   -h, --help          options.help           # => bool
    #   --[no-]feature      options.feature        # => bool
    #   --large-switch      options.large_switch   # => bool
    #   --file FILE         options.file           # => file passed
    #   --list WORDS        options.list           # => array
    #   --date [DATE]       options.date           # => date or nil when optional argument not set
    #
    # === Examples:
    #    
    #   command :something do |c|
    #     c.option '--recursive', 'Do something recursively'
    #     c.option '--file FILE', 'Specify a file'
    #     c.option('--info', 'Display info') { puts "handle with block" }
    #     c.option '--[no-]feature', 'With or without feature'
    #     c.option '--list FILES', Array, 'List the files specified'
    #   
    #     c.when_called do |args, options|
    #       do_something_recursively if options.recursive
    #       do_something_with_file options.file if options.file
    #     end 
    #   end
    #
    # === Help Formatters:
    #
    # This method also parses the arguments passed in order to determine
    # which were switches, and which were descriptions for the
    # option which can later be used within help formatters
    # using option[:switches] and option[:description].
    #
    # === Input Parsing:
    #
    # Since Commander utilizes OptionParser you can pre-parse and evaluate
    # option arguments. Simply require 'optparse/time', or 'optparse/date', as these
    # objects must respond to #parse.
    #
    #   c.option '--time TIME', Time
    #   c.option '--date [DATE]', Date
    #
    
    def option *args, &block
      switches, description = seperate_switches_from_description *args
      proc = block || option_proc(switches)
      @options << {
        :args => args,
        :proc => proc,
        :switches => switches,
        :description => description,
      }
    end
    
    ##
    # Handle execution of command. The handler may be a class, 
    # object, or block (see examples below).
    #
    # === Examples:
    #    
    #   # Simple block handling
    #   c.when_called do |args, options|
    #      # do something
    #   end 
    #   
    #   # Create inst of Something and pass args / options
    #   c.when_called MyLib::Command::Something
    #   
    #   # Create inst of Something and use arbitrary method
    #    c.when_called MyLib::Command::Something, :some_method
    #   
    #   # Pass an object to handle callback (requires method symbol)
    #   c.when_called SomeObject, :some_method
    #
    
    def when_called *args, &block
      raise ArgumentError, 'pass an object, class, or block.' if args.empty? and !block
      @when_called = block ? [block] : args
    end
    
    ##
    # Run the command with _args_.
    #
    # * parses options, call option blocks
    # * invokes when_called proc
    #
    
    def run *args
      call parse_options_and_call_procs(*args)
    end
    
    ##
    # Parses options and calls associated procs, 
    # returning the arguments remaining.
    
    def parse_options_and_call_procs *args
      return args if args.empty?
      @options.inject OptionParser.new do |opts, option| 
        opts.on *option[:args], &option[:proc]
        opts
      end.parse! args
    end
    
    ##
    # Call the commands when_called block with +args+.
    
    def call args = []
      object = @when_called.shift
      meth = @when_called.shift || :call
      options = proxy_option_struct
      case object
      when Proc  ; object.call(args, options)
      when Class ; meth != :call ? object.new.send(meth, args, options) : object.new(args, options)
      else         object.send(meth, args, options) if object
      end 
    end
    
    ##
    # Attempts to generate a method name symbol from +switch+.
    # For example:
    # 
    #   -h                 # => :h
    #   --trace            # => :trace
    #   --some-switch      # => :some_switch
    #   --[with]-feature   # => :feature
    #   --file FILE        # => :file
    #   --list of,things   # => :list
    
    def switch_to_sym switch
      switch.gsub(/\[.*\]/, '').scan(/-([a-z]+)/).join('_').to_sym rescue nil
    end
    
    ##
    # Return switches and description seperated from the +args+ passed.

    def seperate_switches_from_description *args
      switches = args.find_all { |arg| arg.to_s =~ /^-/ } 
      description = args.last unless !args.last.is_a? String or args.last.match(/^-/)
      return switches, description
    end
        
    ##
    # Creates an Options instance populated with the option values
    # collected by the #option_proc.
    
    def proxy_option_struct
      @proxy_options.inject Options.new do |options, (option, value)|
        options.send :"#{option}=", value if option
        options
      end
    end
    
    ##
    # Option proxy proc used when a block is not explicitly passed
    # via the #option method. This allows commander to auto-populate
    # and work with option values.
    
    def option_proc switches
      Proc.new do |value|
        @proxy_options.push [switch_to_sym(switches.last), value]
      end 
    end
    
  end
end