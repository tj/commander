
require "forwardable"

##
# Makes the following Commander methods globally available:
#
# * Commander::Runner#add_command
# * Commander::Runner#get_command
# * Commander::Runner#command
# * Commander::Runner#commands
# * Commander::Runner#program

module Kernel
  extend Forwardable
  def_delegators :$command_runner, :add_command, :get_command, :command, :program, :run!, :commands
  
  def command_runner #:nodoc:
    $command_runner
  end
end