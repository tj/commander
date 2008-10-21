
module Commander
  class Command 
    
    attr_reader :description, :syntax, :examples, :options, :command
    
    def initialize(command)
      @command, @options, @examples = command, [], []
    end

    def set_syntax(text)
      @syntax = text
    end
    
    def set_description(text)
      @description = text
    end
    
    def add_example(description, code)
      @examples << { :description => description, :code => code }
    end
    
    def add_option(*args)
      @options << args
    end
  end
end