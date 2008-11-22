
require "forwardable"

module Kernel
  extend Forwardable
  def_delegators :$command_runner, :add_command, :get_command, :command, :program, :run!, :commands
  
  def command_runner #:nodoc:
    $command_runner
  end
end