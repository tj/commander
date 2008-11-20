
require "forwardable"

module Kernel
  extend Forwardable
  def_delegators :$command_runner, :get_command, :command, :init
end