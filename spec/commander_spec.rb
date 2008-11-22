
describe Commander do
  
	before :each do
	  create_test_command
	end
	
	it "should set program information using #program" do
	  program :name, "test"
	  program :version, "1.2.3"
	  program :description, "just a test."
	  program(:name).should eql("test")
	  program(:version).should eql("1.2.3")
	  program(:description).should eql("just a test.")
	end
	
  it "should raise an error when crutial program info is not set" do
    new_command_runner '--help'
	  program :name, ''
    lambda { run! }.should raise_error(Commander::Runner::Error)
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
	
	it "should locate command within arbitrary arguments passed" do
	  new_command_runner '--help', '--arbitrary', 'test'
	  command_runner.command_name_from_args.should eql(:test)
	end
	
 it "should resolve active command from global options passed" do
   new_command_runner '--help', 'test'
   command_runner.active_command.should be_instance_of(Commander::Command)
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
 
 it "should call the when_called proc when #run" do
   result = nil
   get_command(:test).when_called { |args| result = args.join(' ') }  
   get_command(:test).run ['--trace', 'just', 'some', 'args']
   result.should eql("just some args")
 end

end
