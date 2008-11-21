
describe Commander::HelpFormatter do
  
  it "should display global help using --help switch" do
    input, output = new_command_runner '--help'
    program :help_formatter, Commander::HelpFormatter::Base
    command_runner.run!
    output.string.should eql("Implement global help here")
    # FIXME: issue with OptionParser taking control of --help switch...
  end
  
end