
require 'forwardable'

##
# Make HighLine#colo globally accessable.

module Kernel
  extend Forwardable
  def_delegators :$terminal, :color
end