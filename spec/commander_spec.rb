
require 'stringio'

describe Commander do
  
	before :each do
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
	  get_command(:test).name.should == :test
	end
	
	it "should assign options" do
	  get_command(:test).options.length.should == 2
	end
	
	it "should invoke #when_called with arguments properly" do
	  get_command(:test).call([1,2]).should == "test 12"
	end
	
	it "should resolve active command from array" do
	  # TODO: finish.. 
	  $command_runner.active_command(['--help', 'test', '-v']).should == get_command(:test)
	end
	
end

