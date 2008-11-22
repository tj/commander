
describe Commander::HelpFormatter::Terminal do
  
  it "should format global help correctly" do
    input, output = new_command_runner 'help'
    command_runner.run!
    output.string.should == <<-OUTPUT
  NAME:

    test

  DESCRIPTION:

    something

  SUB-COMMANDS:

    test       test description
    help       Displays help global or sub-command help information

OUTPUT
  end
  
end