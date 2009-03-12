
describe Commander::HelpFormatter do
  
  before :each do
    mock_terminal
  end
  
  def run *args
    new_command_runner *args do
      program :help_formatter, Commander::HelpFormatter::Base
    end.run!    
    @output.string
  end
  
  it "should display global help using --help switch" do
    run('--help').should == "Implement global help here\n"
  end
  
  it "should display global help using help command" do
    run('help').should == "Implement global help here\n"
  end
  
  it "should display command help" do
    run('help', 'test').should == "Implement help for test here\n"
  end
      
end