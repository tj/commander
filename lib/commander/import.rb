
require 'commander'
require 'commander/delegates'

$terminal.wrap_at = HighLine::SystemExtensions.terminal_size.first - 5 rescue 80 if $stdin.tty?
at_exit { run! }

include Commander::UI
include Commander::UI::AskForClass
include Commander::Delegates