
module Commander
	class Command 
		
		attr_accessor :description, :syntax, :examples, :options, :command, :manual
		attr_reader :when_called_proc
		
		def initialize(command)
			@command, @options, @examples = command, [], []
		end
		
		def example(description, code)
			@examples << { :description => description, :code => code }
		end
		
		def option(*args)
			@options << args
		end
		
		def when_called(&block)
		  @when_called_proc = block
		end
		
		def invoke(method_name, *args)
		  send(method_name).call *args
		end
	end
end