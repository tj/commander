
describe Commander::Manager do
  before :each do
    @manager = Commander::Manager.instance 
  end
  
  it "should parse version numbers" do
    @manager.parse_version('1.2.3').should == [1, 2, 3]
  end
  
  it "should validate version numbers" do
    @manager.valid_version?('1.2.3').should == true
  end
  
  it "should invalidate version numbers" do
    @manager.valid_version?('1.2').should_not == true
  end
  
  it "should set the command option of help when first argument is 'help'" do
    instance = new_manager :argv => ['help']
    instance.command_options[:help].should == true
  end
end

def new_manager(*args)
  Commander::Manager.kill_instance!
  init_commander({:version => '0.0.1'}.merge!(*args))
  Commander::Manager.instance.run
  Commander::Manager.instance
end