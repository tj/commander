
describe Commander do
  
	before :each do
    @input = StringIO.new
    @output = StringIO.new
    $terminal = HighLine.new @input, @output
	  create_test_command
	end
	
	it "should allow access to all commands using #commands" do
	  commands.length.should eql(2) # our test command as well as help default
	end
	
	it "should set program information using #program" do
	  program :name, "test"
	  program :version, "1.2.3"
	  program :description, "just a test."
	  program(:name).should eql("test")
	  program(:version).should eql("1.2.3")
	  program(:description).should eql("just a test.")
	end
	
	it "should allow arbitrary blocks of global help documentation" do
	  program :help, 'Copyright', 'TJ Holowaychuk'
	  program(:help)['Copyright'].should eql('TJ Holowaychuk')
	end
	
  it "should raise an error when crutial program info is not set" do
    new_command_runner '--help'
	  program :name, ''
    lambda { run! }.should raise_error(Commander::Runner::CommandError)
  end
  
  it "should output program version using --version switch" do
    new_command_runner '--version'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    @output.string.should eql("test 1.2.3\n")
  end
      	
	it "should get command instances using #get_command" do
	  get_command(:test).name.should eql(:test)
	end
	
	it "should assign options" do
	  get_command(:test).options.length.should eql(2)
	end
	
	it "should invoke #when_called with arguments properly" do
	  get_command(:test).call([1, 2]).should eql("test 12")
	end

  it "should output invalid option message when invalid options passed to command" do
    new_command_runner 'test', '--invalid-option'
    run!
    @output.string.should eql("invalid option: --invalid-option\n")
  end
  
  it "should output invalid command message when help sub-command does not exist" do
    new_command_runner 'help', 'does_not_exist'
    command_runner.run!
    @output.string.should eql("invalid command. Use --help for more information\n")
  end

 	it "should locate command within arbitrary arguments passed" do
 	  new_command_runner '--help', '--arbitrary', 'test'
 	  command_runner.command_name_from_args.should eql(:test)
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
  
  it "should allow multi-word strings as command names" do
    command 'foo bar' do |c|
      c.when_called do |args, opts|
        "foo bar %s" % args.join('-')
      end
    end
    get_command('foo bar').name.should eql('foo bar')
  end

end
