
describe Commander::HelpFormatter do
  
  it "should display global help using --help switch" do
    intput, output = new_command_runner '--help'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    output.string.should eql("Implement global help here\n")
  end
  
  it "should display global help using help command" do
    input, output = new_command_runner 'help'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    output.string.should eql("Implement global help here\n")
  end
  
  it "should display command help" do
    input, output = new_command_runner 'help', 'test'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    output.string.should eql("Implement help for test here\n")
  end
      
end