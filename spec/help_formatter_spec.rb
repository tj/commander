
describe Commander::HelpFormatter do
  
  before :each do
    @input = StringIO.new
    @output = StringIO.new
    $terminal = HighLine.new @input, @output
  end
  
  it "should display global help using --help switch" do
    new_command_runner '--help'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    @output.string.should eql("Implement global help here\n")
  end
  
  it "should display global help using help command" do
    new_command_runner 'help'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    @output.string.should eql("Implement global help here\n")
  end
  
  it "should display command help" do
    new_command_runner 'help', 'test'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    @output.string.should eql("Implement help for test here\n")
  end
      
end