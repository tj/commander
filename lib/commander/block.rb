require 'commander'
require 'commander/methods'

module Commander
  module_function

  def configure(*configuration_opts, &configuration_block)
    configuration_module = Module.new
    configuration_module.extend Commander::Methods
    
    configuration_module.class_exec(*configuration_opts, &configuration_block)

    configuration_module.class_exec do
      run!
    end
  end
end

