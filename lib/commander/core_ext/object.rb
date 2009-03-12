
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
    
  ##
  # Implement #ask_for_CLASS.
  
  include Module.new {
    def method_missing meth, *args, &block
      case meth.to_s
      when /^ask_for_([\w]+)/ ; $terminal.ask(args.first, eval($1.camelcase))
      else super
      end
    end
  }

end
