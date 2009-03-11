
describe Commander::Command do
  
  before :each do
    @input = StringIO.new
    @output = StringIO.new
    $terminal = HighLine.new @input, @output
	  create_test_command
    @command = get_command :test  
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

  it "should call the #when_called proc when #run" do
    result = nil
    get_command(:test).when_called { |args, options| result = args.join(' ') }  
    get_command(:test).run  '--trace', 'just', 'some', 'args'
    result.should eql("just some args")
  end
  
  it "should handle boolean options" do
    opts = nil
    get_command(:test).when_called { |args, options| opts = options }  
    get_command(:test).run '--trace', 'foo', 'bar'
    opts.trace.should be_true
  end
end