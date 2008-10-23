
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
end

