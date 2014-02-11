
module Commander
  module Delegates
    %w( add_command command program run! global_option
        commands alias_command default_command
        always_trace! never_trace! ).each do |meth|
      eval <<-END, binding, __FILE__, __LINE__
        def #{meth} *args, &block
          ::Commander::Runner.instance.#{meth} *args, &block
        end
      END
    end
  end
end
