
describe Commander do
  
	before :each do
	  $stderr = StringIO.new
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
  	  program :version, ''
      lambda { run! }.should raise_error(Commander::Runner::CommandError)
    end
    
    it "should allow aliases of help formatters" do
      program :help_formatter, :compact
      program(:help_formatter).should == Commander::HelpFormatter::TerminalCompact
    end
  end
  
  describe "#command" do
  	it "should return a command instance when only the name is passed" do
  	  command(:test).should be_instance_of(Commander::Command)
  	end
    
    it "should return nil when the command does not exist" do
      command(:im_not_real).should be_nil
    end
  end
  
  describe "#separate_switches_from_description" do
    it "should seperate switches and description returning both" do
      switches, description = *Commander::Runner.separate_switches_from_description('-h', '--help', 'display help')
      switches.should == ['-h', '--help']
      description.should == 'display help'
    end
  end
  
  describe "#switch_to_sym" do
    it "should return a symbol based on the switch name" do
     Commander::Runner.switch_to_sym('--trace').should == :trace
     Commander::Runner.switch_to_sym('--foo-bar').should == :foo_bar
     Commander::Runner.switch_to_sym('--[no-]feature"').should == :feature
     Commander::Runner.switch_to_sym('--[no-]feature ARG').should == :feature
     Commander::Runner.switch_to_sym('--file [ARG]').should == :file
     Commander::Runner.switch_to_sym('--colors colors').should == :colors
    end
  end
  
  describe "#alias_command" do
    it "should alias a command" do
      alias_command :foo, :test
      command(:foo).should == command(:test)
    end
    
    it "should pass arguments passed to the alias when called" do
      gem_name = ''
      new_command_runner 'install', 'gem', 'commander' do
        command :install do |c|
          c.option '--gem-name NAME', 'Install a gem'
          c.when_called { |_, options| gem_name = options.gem_name }
        end 
        alias_command :'install gem', :install, '--gem-name'
      end.run!
      gem_name.should == 'commander'
    end
  end
  
  describe "#global_option" do
    it "should be invoked when used in the args list" do
      file = ''
      new_command_runner 'test', '--config', 'foo' do
        global_option('--config FILE') { |f| file = f }
      end.run!
      file.should == 'foo'
    end
    
    it "should be inherited by commands" do
      quiet = nil
      new_command_runner 'foo', '--quiet' do
        global_option('--quiet', 'Suppress output')
        command :foo do |c|
          c.when_called { |_, options| quiet = options.quiet } 
        end
      end.run!
      quiet.should be_true
    end
    
    it "should be inherited by commands even when a block is present" do
      quiet = nil
      new_command_runner 'foo', '--quiet' do
        global_option('--quiet', 'Suppress output') {}
        command :foo do |c|
          c.when_called { |_, options| quiet = options.quiet } 
        end
      end.run!
      quiet.should be_true      
    end
  end
  
  describe "#remove_global_options" do
    it "should description" do
      options, args = [], []
      options << { :switches => ['-t', '--trace'] }
      options << { :switches => ['--help'] }
      options << { :switches => ['--paths PATHS'] }
      args << '-t'
      args << '--help'
      args << '--command'
      args << '--command-with-arg' << 'rawr'
      args << '--paths' << '"lib/**/*.js","spec/**/*.js"'
      command_runner.remove_global_options options, args
      args.should == ['--command', '--command-with-arg', 'rawr']
    end
  end
  
  describe "--trace" do
    it "should display pretty errors by default" do
      lambda {
        new_command_runner 'foo' do
          command(:foo) { |c| c.when_called { raise 'cookies!' } }
        end.run!
      }.should raise_error(SystemExit, /error: cookies!. Use --trace/)
    end
    
    it "should display callstack when using this switch" do
      lambda {
        new_command_runner 'foo', '--trace' do
          command(:foo) { |c| c.when_called { raise 'cookies!' } }
        end.run!  
      }.should raise_error(RuntimeError)
    end
  end
  
  describe "--version" do
    it "should output program version" do
      run('--version').should == "test 1.2.3\n"
    end
  end
  
  describe "--help" do
    it "should not output an invalid command message" do
      run('--help').should_not == "invalid command. Use --help for more information\n"
    end
  end
  
  describe "with invalid options" do
    it "should output an invalid option message" do
      lambda {
        run('test', '--invalid-option')  
      }.should raise_error(SystemExit, /invalid option: --invalid-option/)
    end
  end
  
  describe "with invalid command passed" do
    it "should output an invalid command message" do
      lambda {
        run('foo')  
      }.should raise_error(SystemExit, /invalid command. Use --help for more information/)
    end
  end
  
  describe "with invalid command passed to help" do
    it "should output an invalid command message" do
      lambda {
        run('help', 'does_not_exist')
      }.should raise_error(SystemExit, /invalid command. Use --help for more information/)
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
    
    it "should return nil when the command is not found" do
      new_command_runner 'foo'
      command_runner.active_command.should be_nil
    end
  end
  
  describe "#default_command" do
    it "should allow you to default any command when one is not explicitly passed" do
      new_command_runner '--trace' do
        default_command :test
        command(:test).should_receive(:run).once
        command_runner.active_command.should == command(:test)
      end.run!
    end
    
    it "should not prevent other commands from being called" do
      new_command_runner 'foo', 'bar', '--trace' do
        default_command :test
        command(:'foo bar'){}
        command(:'foo bar').should_receive(:run).once
        command_runner.active_command.should == command(:'foo bar')
      end.run!
    end
    
    it "should not prevent longer commands to use the same words as the default" do
      new_command_runner 'foo', 'bar', 'something'
      default_command :'foo bar'
      command(:'foo bar'){}
      command(:'foo bar something'){}
      command_runner.active_command.should == command(:'foo bar something')
    end
    
    it "should allow defaulting of command aliases" do
      new_command_runner '--trace' do
        default_command :foobar
        alias_command :foobar, :test
        command(:test).should_receive(:run).once
      end.run!
    end
  end
  
  describe "should function correctly" do
    it "when options are passed before the command name" do
      new_command_runner '--verbose', 'test', 'foo', 'bar' do
        @command.when_called do |args, options|
          args.should == ['foo', 'bar']
          options.verbose.should be_true
        end
      end.run!
    end

    it "when options are passed after the command name" do
      new_command_runner 'test', '--verbose', 'foo', 'bar' do
        @command.when_called do |args, options|
          args.should == ['foo', 'bar']
          options.verbose.should be_true
        end
      end.run!
    end

    it "when an argument passed is the same name as the command" do
      new_command_runner 'test', '--verbose', 'foo', 'test', 'bar' do
        @command.when_called do |args, options|
          args.should == ['foo', 'test', 'bar']
          options.verbose.should be_true
        end
      end.run!
    end
    
    it "when using multi-word commands" do
      new_command_runner '--verbose', 'my', 'command', 'something', 'foo', 'bar' do
        command('my command') { |c| c.option('--verbose') }
        command_runner.command_name_from_args.should == 'my command'
        command_runner.args_without_command_name.should == ['--verbose', 'something', 'foo', 'bar']
      end.run!
    end

    it "when using multi-word commands with parts of the command name as arguments" do
      new_command_runner '--verbose', 'my', 'command', 'something', 'my', 'command' do
        command('my command') { |c| c.option('--verbose') }
        command_runner.command_name_from_args.should == 'my command'
        command_runner.args_without_command_name.should == ['--verbose', 'something', 'my', 'command']
      end.run!
    end
    
    it "when using multi-word commands with other commands using the same words" do
      new_command_runner '--verbose', 'my', 'command', 'something', 'my', 'command' do
        command('my command') {}
        command('my command something') { |c| c.option('--verbose') }
        command_runner.command_name_from_args.should == 'my command something'
        command_runner.args_without_command_name.should == ['--verbose', 'my', 'command']
      end.run!
    end
  end
  
end
