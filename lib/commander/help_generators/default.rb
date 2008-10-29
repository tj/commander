
module Commander
  module HelpGenerators
    
    # Default help generator.
    #
    # Example formatting:
    #   
    #     NAME:
    #     
    #         Program name.
    #
    #     DESCRIPTION:
    #
    #         Short program description here.
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
        @manager = manager
        @command = @manager.user_command
        render
      end
      
      # -----------------------------------------------------------

        protected

      # -----------------------------------------------------------
      
      def render 
        # TODO: support coloring
        # TODO: store and output using 'less'
        say(render_command(@command)) if @command
        say(render_global) unless @command
      end
      
      def render_global
        %w[ name description command_list commands footer ].collect { |v| send("render_#{v}") }.join
      end
      
      def render_name
        o = head 'name'
        o += row 4, @manager.info[:name]
        o += "\n"
        o
      end
      
      def render_description
        o = head 'description'
        o += row 4, @manager.info[:description] unless @manager.info[:description].nil?
        o += "\n"
        o
      end
      
      def render_options
        # TODO: finish
        ""
      end
      
      def render_option(option)
        # TODO: finish
      end
      
      def render_command_list
        o = head 'sub-commands'
        o += @manager.commands.collect { |c, command| row(4, c.to_s, command.description) }.join
        o += "\n"
        o
      end
      
      def render_commands
        o = head 'sub-command details'
        o += @manager.commands.collect { |c, command| render_command(command) }.join
        o += "\n"
        o
      end
      
      def render_command(command)
        o = row 4, command.command
        o += row 4, command.description
        o += "\n" + row(6, 'Examples:') unless command.examples.empty?
        o += render_command_examples command
        o += "\n"
        o
      end
      
      def render_command_examples(command)
        command.examples.collect do |example|
          o = "\n"
          o += row 8, "# #{example[:description]}"
          o += row 8, "#{example[:code]}"
        end.join 
      end
            
      def render_footer
        "\n"
      end
      
      def head(text)
        "\n  #{text.upcase}:\n"
      end
      
      def row(lpad, *args)
        "\n" + (' ' * lpad) + args.collect { |a| a.to_s.ljust(15, ' ') }.join 
      end
    end
  end
end

class Hash
  def collect(&block)
    o = []
    self.each_pair { |k, v| o << block.call(k, v)} 
    o
  end
end