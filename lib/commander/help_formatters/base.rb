
module Commander
  
  ##
  # = Help Formatter
  #
  # Commander's help formatters control the output when
  # either the help command, or --help switch are called.
  # The default formatter is Commander::HelpFormatter::Terminal.
  
  module HelpFormatter
    
    class Base 
      
      ##
      # Access the current command runner via +@runner+.

      def initialize(runner)
        @runner = runner
      end
      
      ##
      # Renders global help.
      
      def render
        "Implement global help here"
      end
      
      ##
      # Renders +command+ specific help.
      
      def render_command(command)
        "Implement help for #{command.name} here"
      end
      
    end
  end
end