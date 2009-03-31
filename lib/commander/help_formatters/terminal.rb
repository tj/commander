
require 'erb'

module Commander
  module HelpFormatter
    class Terminal < Base
      TEMPLATE_DIR = File.expand_path File.join(File.dirname(__FILE__), 'terminal')
      
      def render
        template(:help).result @runner.get_binding
      end
      
      def render_command command
        template(:command_help).result command.get_binding
      end
      
      def template name
        ERB.new(File.read(File.join(TEMPLATE_DIR, "#{name}.erb")), nil, '-')
      end
    end
  end
end