require 'spec_helper'

describe Commander::UI do
  
  describe ".replace_tokens" do
    it "should replace tokens within a string, with hash values" do
      result = Commander::UI.replace_tokens 'Welcome :name, enjoy your :object'.freeze, :name => 'TJ', :object => 'cookie'
      result.should eq('Welcome TJ, enjoy your cookie')
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
  
  describe ".available_editor" do
    it "should not fail on available editors with shell arguments" do
      Commander::UI.available_editor('sh -c').should eq('sh -c')
    end
  end

end
