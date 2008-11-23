
require 'forwardable'

##
# Make HighLine#color available globally.

module Kernel
  extend Forwardable
  def_delegators :$terminal, :color
end