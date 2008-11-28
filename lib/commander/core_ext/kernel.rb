
require 'forwardable'

##
# Make the following methods globally accessable:
#
# * HighLine#color

module Kernel
  extend Forwardable
  def_delegators :$terminal, :color
end