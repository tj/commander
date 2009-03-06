
describe String do
  
  describe "#tokenize" do
    it "should replace tokens within a string, with hash values" do
      s = 'Welcome :name, enjoy your :object'.tokenize  :name => 'TJ', :object => 'cookie'
      s.should == 'Welcome TJ, enjoy your cookie'
    end
    
    it "should not mutate the string" do
      s = 'Hey :msg'
      s.tokenize :msg => 'there'
      s.should_not == 'Hey there'
    end
  end
  
  describe "#tokenize!" do
    it "should mutate the string while replacing tokens" do
      s = 'Hey :msg'
      s.tokenize! :msg => 'there'
      s.should == 'Hey there'
    end
  end
  
end