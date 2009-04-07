
require 'forwardable'

##
# Delegates the following methods:
#
# * Commander::Runner#add_command
# * Commander::Runner#command
# * Commander::Runner#commands
# * Commander::Runner#program
# * Commander::UI::ProgressBar#progress
#

class Object
  
  extend Forwardable
  include Commander::UI
  include Commander::UI::AskForClass
  
  #--
  # UI related delegation.
  #++
  
  def_delegators Commander::UI::ProgressBar, :progress
  
  #--
  # Command runner delegation.
  #++
  
  def_delegators :$command_runner, 
    :add_command, :command, :program, :run!, :global_option,
    :commands, :alias_command, :default_command

  ##
  # Return the current binding.
  
  def get_binding
    binding
  end

  ##
  # Return the current command runner.
  
  def command_runner
    $command_runner
  end

end
