
describe Commander::Command do
  
  before :each do
    mock_terminal
    create_test_command
  end
  
  describe "#option" do
    it "should add options" do
      lambda { @command.option '--recursive' }.should change(@command.options, :length).from(2).to(3)
    end
    
    it "should allow procs as option handlers" do
      @command.option('--recursive') { |recursive| recursive.should be_true }
      @command.run '--recursive'
    end
  end
    
  describe "#options" do
  	it "should distinguish between switches and descriptions" do
  	  @command.option '-t', '--trace', 'some description'
  	  @command.options[2][:description].should == 'some description'
  	  @command.options[2][:switches].should == ['-t', '--trace']
  	end
  end
  
  describe "#sym_from_switch" do
    it "should return a symbol based on the switch name" do
      @command.sym_from_switch('--trace').should == :trace
      @command.sym_from_switch('--foo-bar').should == :foo_bar
      @command.sym_from_switch('--[no]-feature"').should == :feature
      @command.sym_from_switch('--[no]-feature ARG').should == :feature
      @command.sym_from_switch('--file [ARG]').should == :file
      @command.sym_from_switch('--colors colors').should == :colors
    end
  end
  
  describe "#run" do
    describe "should invoke #when_called" do
      it "with arguments parsed" do
        @command.when_called { |args, options| args.join(' ').should == 'just some args' }  
        @command.run '--trace', 'just', 'some', 'args'
      end
      
      it "calling the #call method by default when an object is called" do
        object = mock 'Object'
        object.should_receive(:call).with(an_instance_of(Array), an_instance_of(OpenStruct)).once
        @command.when_called object
        @command.run 'foo'        
      end
            
      it "calling an arbitrary method when an object is called" do
        object = mock 'Object'
        object.should_receive(:foo).with(an_instance_of(Array), an_instance_of(OpenStruct)).once
        @command.when_called object, :foo
        @command.run 'foo'        
      end
    end
    
    describe "should populate options with" do
      it "boolean values" do
        @command.option '--[no-]toggle'
        @command.when_called { |_, options| options.toggle.should be_true }  
        @command.run '--toggle'
        @command.when_called { |_, options| options.toggle.should be_false }  
        @command.run '--no-toggle'
      end

      it "manditory arguments" do
        @command.option '--file FILE'
        @command.when_called { |_, options| options.file.should == 'foo' }  
        @command.run '--file', 'foo'
        lambda { @command.run '--file' }.should raise_error(OptionParser::MissingArgument)
      end  

      it "optional arguments" do
        @command.option '--use-config [file] '
        @command.when_called { |_, options| options.use_config.should == 'foo' }  
        @command.run '--use-config', 'foo'
        @command.when_called { |_, options| options.use_config.should be_nil }  
        @command.run '--use-config'
      end

      it "lists" do
        @command.option '--fav COLORS', Array
        @command.when_called { |_, options| options.fav.should == ['red', 'green', 'blue'] }  
        @command.run '--fav', 'red,green,blue'
      end
      
      it "lists with multi-word items" do
        @command.option '--fav MOVIES', Array
        @command.when_called { |_, options| options.fav.should == ['super\ bad', 'nightmare'] }  
        @command.run '--fav', 'super\ bad,nightmare'        
      end
    end
    
    describe "function correctly" do
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

      it "should allow multi-word strings as command names to be called correctly" do
        # TODO: refactor
        arguments = nil
        options = nil
        new_command_runner 'foo', 'bar', 'something', 'i', 'like', '--i-like', 'cookies'
        command 'foo bar something' do |c|
          c.option '--i-like WHAT'
          c.when_called { |args, opts| arguments, options = args, opts } 
        end
        command_runner.command_name_from_args.should == 'foo bar something'
        command_runner.args_without_command.should == ['i', 'like', '--i-like', 'cookies']
        command_runner.run!
        arguments.should == ['i', 'like']
        options.i_like.should == 'cookies'
      end

      it "should allow multi-word strings as command names to be called correctly, with options before command name" do
        arguments = nil
        options = nil
        new_command_runner '--something', 'foo', 'bar', 'random_arg'
        command 'foo bar' do |c|
          c.option '--something'
          c.when_called { |args, opts| arguments, options = args, opts } 
        end
        command_runner.command_name_from_args.should == 'foo bar'
        command_runner.args_without_command.should == ['--something', 'random_arg']
        command_runner.run!
        arguments.should == ['random_arg']
        options.something.should be_true
      end
    end
  end
  
end