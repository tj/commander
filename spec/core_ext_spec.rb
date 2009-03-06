
describe Commander do
  describe String do
    it "should tokenize strings" do
      s = 'Welcome :name, enjoy your :object'.tokenize({ :name => 'TJ', :object => 'cookie' })
      s.should == 'Welcome TJ, enjoy your cookie'
    end
  end
end