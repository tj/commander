
describe Commander::UI do
  
  describe ".replace_tokens" do
    it "should replace tokens within a string, with hash values" do
      result = Commander::UI.replace_tokens 'Welcome :name, enjoy your :object', :name => 'TJ', :object => 'cookie'
      result.should == 'Welcome TJ, enjoy your cookie'
    end
    
    it "should not mutate the string passed" do
      string = 'Oh I will enjoy my :object'
      result = Commander::UI.replace_tokens string, :object => 'cookies'
      result.should == 'Oh I will enjoy my cookies'
      string.should == 'Oh I will enjoy my :object'
    end
  end

end