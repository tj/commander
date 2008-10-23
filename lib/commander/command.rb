
module Commander
	class Command 
		
		attr_reader :description, :syntax, :examples, :options, :command
		attr_reader :when_called_proc, :manual
		
		def initialize(command)
			@command, @options, @examples = command, [], []
		end

		def set_syntax(text)
			@syntax = text
		end
		
		def set_description(text)
			@description = text
		end
		
		def set_manual(text)
		  @manual = text
		end
		
		def add_example(description, code)
			@examples << { :description => description, :code => code }
		end
		
		def add_option(*args)
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