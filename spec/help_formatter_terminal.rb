
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
  
    it "should format command help correctly" do
      input, output = new_command_runner 'help', 'test'
      command_runner.run!
      output.string.should == <<-OUTPUT

    NAME:

      test

    DESCRIPTION:

      test description

    SYNOPSIS:

      test [options] <file>

    EXAMPLES:

      # description
      command
      
      # description 2
      command 2

    OPTIONS:

      -t, --trace       trace description
      -v, --verbose     verbose description

OUTPUT
    end
      
end