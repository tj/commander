
require 'optparse'
require 'ostruct'

module Commander
  class Command
    
    attr_reader :name, :examples, :options, :proxy_options
    attr_accessor :syntax, :description
        
    ##
    # Initialize new command with specified +name+.
    
    def initialize(name)
      @name, @examples, @when_called = name, [], {}
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
    #    command :something do |c|
    #      c.example "Should do something", "my_command something"
    #    end
    #
    
    def example(description, command)
      @examples << {
        :description => description,
        :command => command,
      }
    end
    
    ##
    # Add an option.
    #
    # Options are parsed via OptionParser so view it
    # for additional usage documentation. This method 
    # also parses the arguments passed in order to determine
    # which were switches, and which were descriptions for the
    # option which can later be used within help formatters
    # using option[:switches] and option[:description].
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
      switches, description = seperate_switches_from_description args
      proc = block_given? ? block : populate_options_to_when_called(switches)
      @options << {
        :args => args,
        :proc => proc,
        :switches => switches,
        :description => description,
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
    
    def when_called(*args, &block)
      h = @when_called
      unless args.empty?
        case args.first
        when Class
          h[:class] = args.shift
          h[:method] = args.shift
        else
          h[:object] = args.shift
          h[:method] = args.shift
        end
      end
      h[:proc] = block if block_given?
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
    
    def call(args = [])
      h = @when_called
      case 
      when h[:class]: h[:class].new.send(h[:method], args, proxy_option_struct)
      when h[:object]: h[:object].send(h[:method], args, proxy_option_struct)
      when h[:proc]: h[:proc].call args, proxy_option_struct
      end
    end
    
    ##
    # Attempts to generate a method name symbol from +switch+.
    # For example:
    # 
    # * -h                 # => :h
    # * --trace            # => :trace
    # * --some-switch      # => :some_switch
    # * --[with]-feature   # => :feature
    # * --file FILE        # => :file
    # * --list of, things  # => :list
    
    def sym_from_switch(switch)
      switch.gsub(/\[.*\]/, '').scan(/-([a-z]+)/).join('_').to_sym rescue nil
    end
    
    private 
    
    def proxy_option_struct #:nodoc:
      options = OpenStruct.new
      @proxy_options.each { |o| options.send("#{o[:method]}=", o[:value]) } 
      options
    end
    
    def seperate_switches_from_description(args) #:nodoc:
      # TODO: refactor this goodness
      switches = args.find_all { |a| a.index('-') == 0 } 
      description = args.last unless args.last.index('-') == 0
      [switches, description]
    end
    
    ##
    # Pass option values to the when_called proc when a block
    # is not specifically supplied to #option.
    
    def populate_options_to_when_called(switches) #:nodoc:
      Proc.new do |args|
        @proxy_options << {
          :method => sym_from_switch(switches.last),
          :value => args,
        }
      end 
    end
    
  end
end