
require 'commander'
$terminal.wrap_at = HighLine::SystemExtensions.terminal_size.first - 5 rescue 80
at_exit { run! }