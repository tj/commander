
require File.dirname(__FILE__) + '/spec_helper'

describe Commander::UI do
  
  describe ".replace_tokens" do
    it "should replace tokens within a string, with hash values" do
      result = Commander::UI.replace_tokens 'Welcome :name, enjoy your :object'.freeze, :name => 'TJ', :object => 'cookie'
      result.should == 'Welcome TJ, enjoy your cookie'
    end
  end

  describe "progress" do
    it "should not die on an empty list" do
      exception = false
      begin
        progress([]) {}
      rescue
        exception = true
      end
      exception.should_not be_true
    end
  end

end
