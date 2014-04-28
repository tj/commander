require 'commander'
require 'commander/delegates'

module Commander::Methods
  include Commander::UI
  include Commander::UI::AskForClass
  include Commander::Delegates

  $terminal.wrap_at = HighLine::SystemExtensions.terminal_size.first - 5 rescue 80 if $stdin.tty?
end

