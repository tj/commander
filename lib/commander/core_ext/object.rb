
require 'forwardable'

##
# Delegates the following methods:
#
# * Commander::Runner#add_command
# * Commander::Runner#get_command
# * Commander::Runner#command
# * Commander::Runner#commands
# * Commander::Runner#program
# * Commander::UI::ProgressBar#progress
#

class Object
  
  extend Forwardable
  include Commander::UI
  
  def_delegators :$command_runner, :add_command, :get_command, :command, :program, :run!, :commands
  def_delegators Commander::UI::ProgressBar, :progress

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
  
  alias_method :original_method_missing, :method_missing
  
  ##
  # Implement #ask_for_CLASS
  
  def method_missing meth, *args, &block
    if meth.to_s =~ /^ask_for_([\w]+)/
      $terminal.ask args.first, eval($1.camelcase)
    else
      original_method_missing(meth, *args, &block)
    end
  end

end
