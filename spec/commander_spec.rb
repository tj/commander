
describe Commander do
  
	before :each do
	  $command_runner = Commander::Runner.new
	  command :test do |c|
	    c.syntax = "test [options] <file>"
	    c.description = "test description"
	    c.example "description", "code"
	    c.option("-h", "--help") {}
	    c.option("-v", "--verbose") {}
	    c.when_called do |args|
	      "test %s" % args.join
	    end
	  end
	
	end
	
	it "should get command instances using #get_command" do
	  get_command(:test).name.should eql(:test)
	end
	
	it "should assign options" do
	  get_command(:test).options.length.should eql(2)
	end
	
	it "should invoke #when_called with arguments properly" do
	  get_command(:test).call([1,2]).should eql("test 12")
	end
	
	it "should resolve active command from global options passed" do
	  $command_runner = Commander::Runner.new $stdin, $stdout, ['--help', 'test']
	  $command_runner.active_command.should eql(get_command(:test))
	end
	
	it "should resolve active command from invalid options passed" do
	  $command_runner = Commander::Runner.new $stdin, $stdout, ['--help', 'test', '--arbitrary']
	  $command_runner.active_command.should eql(get_command(:test))
	end
	
end

