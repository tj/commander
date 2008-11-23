
require 'forwardable'

##
# Make HighLine#color and Commander::UserInteraction globally accessable.

module Kernel
  extend Forwardable
  def_delegators :$terminal, :color
  include Commander::UserInteraction
end