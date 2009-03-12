
describe Commander do
  
	before :each do
    mock_terminal
	  create_test_command
	end
	
  describe "#program" do
    it "should set / get program information" do
      program :name, 'test'
  	  program(:name).should == 'test'
    end
    
    it "should allow arbitrary blocks of global help documentation" do
      program :help, 'Copyright', 'TJ Holowaychuk'
  	  program(:help)['Copyright'].should == 'TJ Holowaychuk'
    end
    
    it "should raise an error when required info has not been set" do
      new_command_runner '--help'
  	  program :name, ''
      lambda { run! }.should raise_error(Commander::Runner::CommandError)
    end
  end
  
  describe "#get_command" do
  	it "should return a command instance" do
  	  get_command(:test).should be_instance_of(Commander::Command)
  	end

  	it "should assign options" do
  	  get_command(:test).should have(2).options
  	end

  	it "should invoke #when_called with arguments properly" do
  	  get_command(:test).call([1, 2]).should == 'test 12'
  	end
  end
  
  describe "--version" do
    it "should output program version" do
      new_command_runner '--version' do
        program :help_formatter, Commander::HelpFormatter::Base
      end.run!
      @output.string.should == "test 1.2.3\n"
    end
  end
  
  describe "with invalid options" do
    it "should output an invalid option message" do
      new_command_runner('test', '--invalid-option').run!
      @output.string.should == "invalid option: --invalid-option\n"
    end
  end

  describe "with invalid sub-command passed to help" do
    it "should output an invalid command message" do
      new_command_runner('help', 'does_not_exist').run!
      @output.string.should == "invalid command. Use --help for more information\n"
    end
  end
  
  describe "#command_name_from_args" do
    it "should locate command within arbitrary arguments passed" do
   	  new_command_runner '--help', '--arbitrary', 'test'
   	  command_runner.command_name_from_args.should eql('test')
    end
  end
  
  describe "#active_command" do
    it "should resolve the active command" do
      new_command_runner '--help', 'test'
      command_runner.active_command.should be_instance_of(Commander::Command)
    end
    
    it "should resolve active command when invalid options are passed" do
      new_command_runner '--help', 'test', '--arbitrary'
      command_runner.active_command.should be_instance_of(Commander::Command)
    end

    it "should raise invalid command error when the command is not found"do
      new_command_runner '--help'
      lambda { command_runner.active_command }.should raise_error(Commander::Runner::InvalidCommandError)
    end
  end
  	
end
