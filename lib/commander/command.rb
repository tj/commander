
module Commander
  class Command
    
    attr_reader :name, :examples, :options, :when_called_proc
    attr_accessor :syntax, :description
    
    def initialize(name)
      @name, @examples, @options = name, [], []
    end
    
    def example(description, code)
      @examples << {
        :description => description,
        :code => code,
      }
    end
    
    def option(*args, &block)
      @options << {
        :args => args,
        :proc => block,
      }
    end
    
    def when_called(&block)
      @when_called_proc = block
    end
    
    def call(*args)
      @when_called_proc.call(*args)
    rescue NoMethodError
      raise "Command '%s' requires #when_called block to be called" % name
    end
  end
end