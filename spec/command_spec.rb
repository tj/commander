
describe Commander::Command do
  
  before :each do
    create_faux_terminal
    @command = create_test_command
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
    it "should call #when_called with parsed arguments" do
      @command.when_called { |args, options| args.join(' ').should == 'just some args' }  
      @command.run '--trace', 'just', 'some', 'args'
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
    end
  end
  
end