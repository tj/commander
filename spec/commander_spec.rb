
describe Commander do
  
	before :each do
    @input = StringIO.new
    @output = StringIO.new
    $terminal = HighLine.new @input, @output
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

  it "should output invalid option message when invalid options passed to command" do
    new_command_runner('test', '--invalid-option').run!
    @output.string.should == "invalid option: --invalid-option\n"
  end
  
  it "should output invalid command message when help sub-command does not exist" do
    new_command_runner('help', 'does_not_exist').run!
    @output.string.should eql("invalid command. Use --help for more information\n")
  end

 	it "should locate command within arbitrary arguments passed" do
 	  new_command_runner '--help', '--arbitrary', 'test'
 	  command_runner.command_name_from_args.should eql('test')
 	end

  it "should resolve active command from global options passed" do
    new_command_runner '--help', 'test'
    command_runner.active_command.should be_instance_of(Commander::Command)
  end
    	
	it "should distinguish between switches and descriptions passed to #option" do
	  get_command(:test).options[0][:description].should eql("trace description")
	  get_command(:test).options[0][:switches].should eql(["-t", "--trace"])
	  get_command(:test).options[1][:description].should eql("verbose description")
	  get_command(:test).options[1][:switches].should eql(["--verbose"])
	  get_command(:test).option "--test"
	  get_command(:test).options[2][:description].should be_nil
	  get_command(:test).options[2][:switches].should eql(["--test"])
	end

  it "should generate a symbol from switches" do
    get_command(:test).sym_from_switch("--trace").should eql(:trace)
    get_command(:test).sym_from_switch("--foo-bar").should eql(:foo_bar)
    get_command(:test).sym_from_switch("--[no]-feature").should eql(:feature)
    get_command(:test).sym_from_switch("--[no]-feature ARG").should eql(:feature)
    get_command(:test).sym_from_switch("--file [ARG]").should eql(:file)
    get_command(:test).sym_from_switch("--colors colors").should eql(:colors)
  end
  	
  it "should resolve active command from invalid options passed" do
    new_command_runner '--help', 'test', '--arbitrary'
    command_runner.active_command.should be_instance_of(Commander::Command)
  end
  
  it "should raise invalid command error when the command is not found in the arguments passed"do
    new_command_runner '--help'
    lambda { command_runner.active_command }.should raise_error(Commander::Runner::InvalidCommandError)
  end
  
  it "should add options to previously created commands" do
    get_command(:test).option("--recursive") {}
    get_command(:test).options.length.should eql(3)
  end
  
  it "should call command option procs" do
    recursive = false
    get_command(:test).option("--recursive") { recursive = true }
    get_command(:test).run ['--recursive']
    recursive.should be_true
  end
  
  it "should call the #when_called proc when #run" do
    result = nil
    get_command(:test).when_called { |args, options| result = args.join(' ') }  
    get_command(:test).run ['--trace', 'just', 'some', 'args']
    result.should eql("just some args")
  end
  
  it "should handle boolean options" do
    opts = nil
    get_command(:test).when_called { |args, options| opts = options }  
    get_command(:test).run ['--trace', 'foo', 'bar']
    opts.trace.should be_true
  end
  
  it "should handle toggle options" do
    options = nil
    get_command(:test).when_called { |args, opts| options = opts }  
    get_command(:test).option "--[no-]toggle"
    get_command(:test).run ['--no-toggle']
    options.toggle.should be_false
  end
  
  it "should handle manditory arg options" do
    options = nil
    get_command(:test).when_called { |args, opts| options = opts }  
    get_command(:test).option "--manditory ARG"
    get_command(:test).run ['--manditory', "foo"]
    options.manditory.should eql("foo")
    lambda { get_command(:test).run ['--manditory'] }.should raise_error(OptionParser::MissingArgument)
  end  
  
  it "should handle optional arg options" do
    options = nil
    get_command(:test).when_called { |args, opts| options = opts }  
    get_command(:test).option "--optional [ARG]"
    get_command(:test).run ['--optional', "foo"]
    options.optional.should eql("foo") 
    get_command(:test).run ['--optional']
    options.optiona.should be_nil  
  end
  
  it "should handle list options" do
    options = nil
    get_command(:test).when_called { |args, opts| options = opts }  
    get_command(:test).option "--list words", Array
    get_command(:test).run ['--list', "im,a,list"]
    options.list.should eql(["im", "a", "list"]) 
  end
  
  it "should initialize and call object when a class is passed to #when_called" do
   $_when_called_value = nil
   class HandleWhenCalled1
     def initialize(args, options) $_when_called_value = args.join('-') end 
   end
   get_command(:test).when_called HandleWhenCalled1
   get_command(:test).call(["hello", "world"])
   $_when_called_value.should eql("hello-world")
  end
   
  it "should initialize and call object when a class is passed to #when_called with an arbitrary method" do
   class HandleWhenCalled2
     def arbitrary_method(args, options) args.join('-') end 
   end
   get_command(:test).when_called HandleWhenCalled2, :arbitrary_method
   get_command(:test).call(["hello", "world"]).should eql("hello-world")
  end
  
  it "should call object when passed to #when_called " do
    class HandleWhenCalled3
      def arbitrary_method(args, options) args.join('-') end 
    end
    get_command(:test).when_called HandleWhenCalled3.new, :arbitrary_method
    get_command(:test).call(["hello", "world"]).should eql("hello-world")
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
