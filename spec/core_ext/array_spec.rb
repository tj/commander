
describe Array do
  
  describe "#delete_switches" do
    it "should delete switches such as -h or --help, returning a new array" do
      ['foo', '-h', 'bar', '--help'].delete_switches.should == ['foo', 'bar']
    end
  end

end