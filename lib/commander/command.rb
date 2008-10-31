
module Commander
	class Command 
		
		attr_accessor :description, :syntax, :examples, :options, :command, :manual
		attr_reader :when_called_proc
		
		def initialize(command)
			@command, @options, @examples = command, [], []
		end
		
		# Adds an example in the help documentation of this sub-command. 
		def example(description, code) 
			@examples << { :description => description, :code => code }
		end
		
		# Adds an option or 'flag'. These are parsed with +OptionParser+
		# so please view its documentation for help.
		def option(*args, &block)
			@options << { :args => args, :proc => block }
		end
		
		# This proc is called when the sub-command is invoked. 
		# The proc has instant access to all methods found in 
		# interaction.rb
		def when_called(&block)
		  @when_called_proc = block
		end
		
		def invoke(method_name, *args)
		  send(method_name).call *args
		end
	end
end