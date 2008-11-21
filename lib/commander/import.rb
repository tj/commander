
require "forwardable"

module Kernel
  extend Forwardable
  def_delegators :$command_runner, :add_command, :get_command, :command, :init
end