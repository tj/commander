
require File.dirname(__FILE__) + '/../spec_helper'

describe Commander::HelpFormatter do
  
  before :each do
    mock_terminal
  end
  
  it "should display global help using --help switch" do
    run('--help').should == "Implement global help here\n"
  end
  
  it "should display global help using help command" do
    run('help').should == "Implement global help here\n"
  end
  
  it "should display command help" do
    run('help', 'test').should == "Implement help for test here\n"
  end
  
  it "should display command help using --help switch" do
    run('--help', 'test').should == "Implement help for test here\n"
  end
      
end