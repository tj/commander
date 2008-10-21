
require File.expand_path(File.dirname(__FILE__) + '/../lib/commander')

# TODO: how to use class << self and @@ properly...
# TODO: how have getters and setters..?
# TODO: hook into exec to run init_commander?
# TODO: allow sub-sub commands? create module, etc
# TODO: abstract spec

describe Commander do
	
	before :each do
		init_commander :version => '1.3.2', :name => 'My Program'
		add_command :test_command do |c|
			c.set_syntax 'test_command [options]'
			c.set_description 'Just a test command.'
			c.add_option '-h', '--help', 'View help information.'
			c.add_option '--version', 'View program version.'
			c.add_option '-v', '--verbose', 'Verbose output.'
			c.add_example 'View help', 'test_command --help'
			c.add_example 'View version', 'test_command --version'
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
		get_info(:version).should == '1.3.2'
		get_info(:major).should == 1
		get_info(:minor).should == 3
		get_info(:tiny).should == 2
	end
	
	it "should set program name" do
		get_info(:name).should == 'My Program'
	end
end

