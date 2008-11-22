
require 'erb'

module Commander
  module HelpFormatter
    class Terminal < Base
      
      def render
        # TODO: pre-process options, add switches and description keys based on ^-
        puts template(:help).result @runner.get_binding
      end
      
      def render_command(command)
        puts template(:command_help).result command.get_binding
      end
      
      def template(name)
        ERB.new(File.read(File.expand_path(File.dirname(__FILE__)) + "/terminal/#{name}.erb"), nil, "<>")
      end
    end
  end
end