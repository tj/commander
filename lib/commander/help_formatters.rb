
module Commander
  module HelpFormatter
    autoload :Base, 'commander/help_formatters/base'
    autoload :Terminal, 'commander/help_formatters/terminal'
    autoload :TerminalCompact, 'commander/help_formatters/terminal_compact'

    module_function
    def indent amount, text
      text.gsub("\n", "\n" + (' ' * amount))
    end
  end
end
