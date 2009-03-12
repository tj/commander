
describe Commander do
  
	before :each do
    create_faux_terminal
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
      new_command_runner '--version'
      program :help_formatter, Commander::HelpFormatter::Base
      command_runner.run!
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
  	
  it "should initialize and call object when a class is passed to #when_called" do
   $_when_called_value = nil
   class HandleWhenCalled1
     def initialize(args, options) $_when_called_value = args.join('-') end 
   end
   get_command(:test).when_called HandleWhenCalled1
   get_command(:test).run "hello", "world"
   $_when_called_value.should eql("hello-world")
  end
   
  it "should initialize and call object when a class is passed to #when_called with an arbitrary method" do
   class HandleWhenCalled2
     def arbitrary_method(args, options) args.join('-') end 
   end
   get_command(:test).when_called HandleWhenCalled2, :arbitrary_method
   get_command(:test).run("hello", "world").should eql("hello-world")
  end
  
  it "should call object when passed to #when_called " do
    class HandleWhenCalled3
      def arbitrary_method(args, options) args.join('-') end 
    end
    get_command(:test).when_called HandleWhenCalled3.new, :arbitrary_method
    get_command(:test).run("hello", "world").should eql("hello-world")
  end
  
  it "should populate options when passed before command name" do
    options = nil
    new_command_runner '--foo', 'test', 'some', 'args'
    get_command(:test).option "--foo"
    get_command(:test).when_called { |args, opts| options = opts }
    command_runner.run!
    options.foo.should be_true 
  end
  
  it "should populate options when passed after command name" do
    options = nil
    new_command_runner 'test', '--foo', 'some', 'args'
    get_command(:test).option "--foo"
    get_command(:test).when_called { |args, opts| options = opts }
    command_runner.run!
    options.foo.should be_true 
  end
  
  it "should allow multi-word strings as command names to be called correctly" do
    arguments = nil
    options = nil
    new_command_runner 'foo', 'bar', 'something', 'i', 'like', '--i-like', 'cookies'
    command 'foo bar something' do |c|
      c.option '--i-like WHAT'
      c.when_called { |args, opts| arguments, options = args, opts } 
    end
    command_runner.command_name_from_args.should eql('foo bar something')
    command_runner.args_without_command.should eql(['i', 'like', '--i-like', 'cookies'])
    command_runner.run!
    arguments.should eql(['i', 'like'])
    options.i_like.should eql('cookies')
  end
  
  it "should allow multi-word strings as command names to be called correctly, with options before command name" do
    arguments = nil
    options = nil
    new_command_runner '--something', 'foo', 'bar', 'random_arg'
    command 'foo bar' do |c|
      c.option '--something'
      c.when_called { |args, opts| arguments, options = args, opts } 
    end
    command_runner.command_name_from_args.should eql('foo bar')
    command_runner.args_without_command.should eql(['--something', 'random_arg'])
    command_runner.run!
    arguments.should eql(['random_arg'])
    options.something.should be_true
  end


end
