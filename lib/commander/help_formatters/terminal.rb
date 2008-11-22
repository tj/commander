
require 'erb'

module Commander
  module HelpFormatter
    class Terminal < Base
      
      def render
        # TODO: get <% -%> working to clean up erb files.. 
        template(:help).result @runner.get_binding
      end
      
      def render_command(command)
        template(:command_help).result @runner.get_binding
      end
      
      def template(name)
        ERB.new File.read(File.expand_path(File.dirname(__FILE__)) + "/terminal/#{name}.erb")
      end
    end
  end
end