
describe Array do
  
  describe "#delete_switches" do
    it "should delete switches such as -h or --help, returning a new array" do
      ['foo', '-h', 'bar', '--help'].delete_switches.should == ['foo', 'bar']
    end
  end
  
  describe "#parse" do
    it "should seperate a list of words into an array" do
      Array.parse('just a test').should == ['just', 'a', 'test']
    end
    
    it "should preserve escaped whitespace" do
      Array.parse('just a\ test').should == ['just', 'a test']
    end
  end

end