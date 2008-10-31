
describe Commander do
	
	before :each do
		init_commander :version => '1.3.2', :name => 'My Program'
		command :test_command do |c|
			c.syntax = 'test_command [options]'
			c.description = 'Just a test command.'
			c.option '-h', '--help', 'View help information.'
			c.option '--version', 'View program version.'
			c.option '-v', '--verbose', 'Verbose output.'
			c.example 'View help', 'test_command --help'
			c.example 'View version', 'test_command --version'
		end
		@manager = Commander::Manager.instance
	end
	
	it "should add commands" do
		@manager.length.should == 1
	end
	
	it "should fetch commands with the #get_command method" do
		get_command(:test_command).syntax.should == 'test_command [options]'
	end
	
	it "should test existance of a command using #command_exists?" do
		command_exists?(:test_command).should == true
		command_exists?(:test).should == false
	end
	
	it "should inialize and set the version" do
		info(:version).should == '1.3.2'
		info(:major).should == 1
		info(:minor).should == 3
		info(:tiny).should == 2
	end
	
	it "should set program name" do
		info(:name).should == 'My Program'
	end
end

