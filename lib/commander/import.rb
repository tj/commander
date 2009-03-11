
require "forwardable"

##
# Makes the following Commander methods globally accessable:
#
# * Commander::Runner#add_command
# * Commander::Runner#get_command
# * Commander::Runner#command
# * Commander::Runner#commands
# * Commander::Runner#program
# * Commander::UI::ProgressBar#progress

module Kernel
  extend Forwardable
  def_delegators :$command_runner, :add_command, :get_command, :command, :program, :run!, :commands
  def_delegators Commander::UI::ProgressBar, :progress
  
  def command_runner #:nodoc:
    $command_runner
  end
  
  def method_missing meth, *args, &block
    if meth.to_s =~ /^ask_for_([\w]+)/
      $terminal.ask args.first, eval($1.camelcase)
    else
      super
    end
  end
  
end