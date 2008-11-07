
module Commander
  module HelpGenerators
    
    # Default help generator.
    #
    # Example formatting:
    #   
    #   NAME:
    #   
    #       Commander-init 
    #   
    #   DESCRIPTION:
    #   
    #       Initialize an empty file with a commander skeleton.
    #   
    #   EXAMPLES:
    #   
    #       # Apply commander to a blank file.
    #       commander init ./bin/my_executable
    #   
    #   OPTIONS:
    #   
    #       -r,  --recursive,  Do something recursively
    #       -v,  --verbose,  Do something verbosely
    #
    class Default
      
      attr_reader :manager
      
      def initialize(manager)
        $terminal.page_at = 22
        @manager = manager
        @command = @manager.user_command
        render
      end
      
      # -----------------------------------------------------------

        protected

      # -----------------------------------------------------------
      
      def render 
        say(render_command(@command)) if @command
        say(render_global) unless @command
      end
      
      def render_global
        %w[ name description command_list copyright ].collect { |v| send("render_#{v}") }.join
      end
      
      def render_name
        o = head 'name'
        o += row 6, @manager.info[:name]
        o += "\n"
        o
      end
      
      def render_description
        return if @manager.info[:description].nil?
        o = head 'description'
        o += row 6, @manager.info[:description]
        o += "\n"
        o
      end
      
      def render_command_list
        o = head 'sub-commands'
        o += @manager.commands.collect { |c, command| row(6, c.to_s, command.description) }.join
        o += row 6, "help", "Display this help information, or help for the trailing sub-command."
        o += "\n"
        o
      end
      
      def render_command(command)
        o = head 'name'
        o += row 6, "#{@manager.info[:name]}-#{command.command}"
        o += "\n"
        
        o += head 'description'
        o += row 6, command.description
        o += "\n"
        
        o += head 'synopsis'
        o += row 6, command.syntax
        o += "\n"
        
        o += head('examples') unless command.examples.empty?
        o += render_command_examples command
        o += "\n"
        
        o += head('options') unless command.options.empty?
        o += render_command_options command
        o += "\n\n"
        o
      end
      
      def render_command_options(command)
        command.options.collect { |option| row(6, option[:args].join(',  '))  }.join
      end
      
      def render_command_examples(command)
        command.examples.collect do |example|
          o = row 6, "# #{example[:description]}"
          o += row 6, "#{example[:code]}"
        end.join "\n"
      end
            
      def render_copyright
        @manager.info[:copyright].nil? ? "\n" : head('copyright') + row(6, @manager.info[:copyright]) + "\n\n";
      end
      
      def head(text)
        "\n  <%= color('#{text.upcase}', BOLD) %>:\n"
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