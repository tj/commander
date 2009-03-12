
describe Object do
  
  describe "#get_binding" do
    it "should return the objects binding" do
      lambda {}.get_binding.should be_instance_of(Binding)
    end
  end
  
end