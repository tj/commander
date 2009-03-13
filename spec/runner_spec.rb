
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
  
  describe "#command" do
  	it "should return a command instance when only the name is passed" do
  	  command(:test).should be_instance_of(Commander::Command)
  	end
    
    it "should raise InvalidCommandError when the command does not exist" do
      lambda { command(:im_not_real) }.should raise_error(Commander::Runner::InvalidCommandError)
    end
  end
  
  describe "#alias_command" do
    it "should alias a command" do
      alias_command :foo, :test
      command(:foo).should == command(:test)
    end
    
    it "should pass arguments passed to the alias when called" do
      new_command_runner 'install', 'gem', 'commander' do
        command :install do |c|
          c.option '--gem-name NAME', 'Install a gem'
          c.when_called { |_, options| options.gem_name.should == 'commander' }
        end 
        alias_command :'install gem', :install, '--gem-name'
        command(:install).should_receive(:run).once
      end.run!
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
  
  describe "--help" do
    it "should not output an invalid command message" do
      new_command_runner('--help').run!
      @output.string.should_not == "invalid command. Use --help for more information\n"
    end
  end
  
  describe "with invalid options" do
    it "should output an invalid option message" do
      new_command_runner('test', '--invalid-option').run!
      @output.string.should == "invalid option: --invalid-option\n"
    end
  end
  
  describe "with invalid sub-command passed" do
    it "should output an invalid command message" do
      new_command_runner('foo').run!
      @output.string.should == "invalid command. Use --help for more information\n"
    end
  end
  
  describe "with invalid sub-command passed to help" do
    it "should output an invalid command message" do
      new_command_runner('help', 'does_not_exist').run!
      @output.string.should == "invalid command. Use --help for more information\n"
    end
  end
  
  describe "#valid_command_names_from" do
    it "should return array of valid command names" do
      command('foo bar') {}
   	  command('foo bar foo') {}
   	  command_runner.valid_command_names_from('foo', 'bar', 'foo').should == ['foo bar', 'foo bar foo']
    end
    
    it "should return empty array when no possible command names exist" do
   	  command_runner.valid_command_names_from('fake', 'command', 'name').should == []
    end
  end
  
  describe "#command_name_from_args" do
    it "should locate command within arbitrary arguments passed" do
   	  new_command_runner '--help', '--arbitrary', 'test'
   	  command_runner.command_name_from_args.should == 'test'
    end
    
    it "should support multi-word commands" do
   	  new_command_runner '--help', '--arbitrary', 'some', 'long', 'command', 'foo'
   	  command('some long command') {}
   	  command_runner.command_name_from_args.should == 'some long command'
    end
    
    it "should match the longest possible command" do
   	  new_command_runner '--help', '--arbitrary', 'foo', 'bar', 'foo'
   	  command('foo bar') {}
   	  command('foo bar foo') {}
   	  command_runner.command_name_from_args.should == 'foo bar foo'      
    end
    
    it "should use the left-most command name when multiple are present" do
   	  new_command_runner 'help', 'test'
   	  command_runner.command_name_from_args.should == 'help'      
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
    
    it "should raise invalid command error when the command is not found" do
      new_command_runner 'foo'
      lambda { command_runner.active_command }.should raise_error(Commander::Runner::InvalidCommandError)
    end
  end
  
  describe "should function correctly" do
    it "when options are passed before the command name" do
      new_command_runner '--trace', 'test', 'foo', 'bar' do
        @command.when_called do |args, options|
          args.should == ['foo', 'bar']
          options.trace.should be_true
        end
      end.run!
    end

    it "when options are passed after the command name" do
      new_command_runner 'test', '--trace', 'foo', 'bar' do
        @command.when_called do |args, options|
          args.should == ['foo', 'bar']
          options.trace.should be_true
        end
      end.run!
    end

    it "when an argument passed is the same name as the command" do
      new_command_runner 'test', '--trace', 'foo', 'test', 'bar' do
        @command.when_called do |args, options|
          args.should == ['foo', 'test', 'bar']
          options.trace.should be_true
        end
      end.run!
    end
    
    it "when using multi-word commands" do
      new_command_runner '--trace', 'my', 'command', 'something', 'foo', 'bar' do
        command('my command') {}
        command_runner.command_name_from_args.should == 'my command'
        command_runner.args_without_command_name.should == ['--trace', 'something', 'foo', 'bar']
      end.run!
    end

    it "when using multi-word commands with parts of the command name as arguments" do
      new_command_runner '--trace', 'my', 'command', 'something', 'my', 'command' do
        command('my command') {}
        command_runner.command_name_from_args.should == 'my command'
        command_runner.args_without_command_name.should == ['--trace', 'something', 'my', 'command']
      end.run!
    end
  end
  
end
