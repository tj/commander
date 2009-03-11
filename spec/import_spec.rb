describe Kernel do
  
  describe "#method_missing" do
    it "should preserve its original behavior for missing methods" do
      lambda { i_am_a_missing_method() }.should raise_error(NoMethodError)
    end
    
    it "should preserve its original behavior for missing variables" do
      lambda { i_am_a_missing_variable }.should raise_error(NameError)
    end
  end
  
end