
module Commander
  module HelpGenerators
    
    # Default help generator.
    #
    # Example formatting:
    #   
    #     Program/command Name
    #
    #     Short program description here.
    #
    #     OPTIONS:
    #
    #         -h, --help       Display this help information.
    #
    #     SUB-COMMANDS:
    #
    #         com1             Description of com1.
    #         com2             Description of com2.
    #         com3             Description of com3.
    #
    #     SUB-COMMAND DETAILS:
    #
    #         com1
    #           Manual or short description of com1.
    #
    #           Options:
    #
    #           -c, --core          Set core value.
    #           -r, --recursive     Set core value.
    #         
    #           Examples:
    #            
    #              # Description of example here.
    #              example code
    #
    #              # Description of example 2 here.
    #              example code 2
    #
    class Default
      
      attr_reader :manager
      
      def initialize(manager)
        # TODO: rspec tests for help generators
        @manager = manager
        render
      end
      
      # -----------------------------------------------------------

        protected

      # -----------------------------------------------------------
      
      def render 
        # TODO: puts before %w ??
        %w[ header options commands footer ].each do |meth|
          output ||= '' and output += send("render_#{meth}")
        end
        puts output and exit
      end
      
      def render_header
        "\n#{@manager.info[:name]}\n"
        "\n#{@manager.info[:description]}\n" unless @manager.info[:description].nil?
      end
      
      def render_options
        # TODO: finish
        ""
      end
      
      def render_option(option)
        # TODO: finish
      end
      
      def render_commands
        @manager.commands.collect { |command| render_command(command) }.join "\n"  
      end
      
      def render_command(command)
        output = "         #{command.command}"
        output += "\n\n           Options:\n"
        output += "\n\n           Examples:\n"
        output += render_examples command
        output
      end
      
      def render_examples(command)
        command.examples.collect { |example| render_example(example) }.join "\n" 
      end
      
      def render_example(example)
        output = "\n               # #{example[:description]}\n"
        output = "\n               #{example[:code]}\n"
        output       
      end
      
      def render_footer
        "\n"
      end
    end
  end
end