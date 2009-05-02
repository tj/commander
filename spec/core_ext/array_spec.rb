
describe Array do
  
  describe "#parse" do
    it "should seperate a list of words into an array" do
      Array.parse('just a test').should == ['just', 'a', 'test']
    end
    
    it "should preserve escaped whitespace" do
      Array.parse('just a\ test').should == ['just', 'a test']
    end
  end

end