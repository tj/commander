
module Commander
  module HelpFormatter
    class Base 
      
      def initialize(runner)
        @runner = runner
      end
      
      def render_help
        "Implement global help here"
      end
      
      def render_command_help(command)
        "Implement help for #{command.name} here"
      end
      
    end
  end
end