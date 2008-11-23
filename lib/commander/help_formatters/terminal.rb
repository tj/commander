
require 'erb'

module Commander
  module HelpFormatter
    
    ##
    # = Terminal
    #
    # Outputs help in a terminal friendly format,
    # utilizing coloring via the highline gem.
    
    class Terminal < Base
      
      def render
        template(:help).result @runner.get_binding
      end
      
      def render_command(command)
        template(:command_help).result command.get_binding
      end
      
      def template(name)
        ERB.new(File.read(File.expand_path(File.dirname(__FILE__)) + "/terminal/#{name}.erb"), nil, "<>")
      end
      
    end
  end
end