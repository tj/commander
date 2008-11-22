
describe Commander::HelpFormatter do
  
  it "should display global help using help command" do
    input, output = new_command_runner 'help'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    output.string.should eql("Implement global help here")
  end
  
  it "should display command help" do
    input, output = new_command_runner 'help', 'test'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    output.string.should eql("Implement help for test here")
  end
  
  it "should display invalid command message when help sub-command does not exist" do
    input, output = new_command_runner 'help', 'does_not_exist'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    output.string.should eql("Invalid command. Use --help for more information\n")
  end
      
end