
require 'commander/help_formatters/base'

module Commander
  module HelpFormatter
    autoload :Terminal, 'commander/help_formatters/terminal'
    autoload :TerminalCompact, 'commander/help_formatters/terminal_compact'
  end
end