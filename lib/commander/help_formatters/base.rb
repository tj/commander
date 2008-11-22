
module Commander
  module HelpFormatter
    class Base 
      
      def initialize(runner)
        @runner = runner
      end
      
      def render
        "Implement global help here"
      end
      
      def render_command(command)
        "Implement help for #{command.name} here"
      end
      
    end
  end
end