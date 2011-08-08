require 'spec_helper'

describe Commander::HelpFormatter::Terminal do
  
  before :each do
    mock_terminal
  end
  
  describe "global help" do
    before :each do
      new_command_runner 'help' do
        command :'install gem' do |c|
          c.syntax = 'foo install gem [options]'
          c.summary = 'Install some gem'
        end
      end.run!
      @global_help = @output.string
    end
    
    describe "should display" do
      it "the command name" do
        @global_help.should include('install gem')
      end
      
      it "the summary" do
        @global_help.should include('Install some gem')
      end
    end
  end
  
  describe "command help" do
    before :each do
      new_command_runner 'help', 'install', 'gem' do
        command :'install gem' do |c|
          c.syntax = 'foo install gem [options]'
          c.summary = 'Install some gem'
          c.description = 'Install some gem, blah blah blah'
          c.example 'one', 'two'
          c.example 'three', 'four'
        end
      end.run!
      @command_help = @output.string
    end
    
    describe "should display" do
      it "the command name" do
        @command_help.should include('install gem')
      end
      
      it "the description" do
        @command_help.should include('Install some gem, blah blah blah')
      end
      
      it "all examples" do
        @command_help.should include('# one')
        @command_help.should include('two')
        @command_help.should include('# three')
        @command_help.should include('four')
      end
      
      it "the syntax" do
        @command_help.should include('foo install gem [options]')
      end
    end
  end
  
end
