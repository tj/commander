
require 'erb'

module Commander
  module HelpFormatter
    class TerminalCompact < Terminal
      TEMPLATE_DIR = File.expand_path File.join(File.dirname(__FILE__), 'terminal_compact')
    end
  end
end