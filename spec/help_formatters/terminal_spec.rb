
describe Commander::HelpFormatter::Terminal do
  
  before :each do
    mock_terminal
  end
  
  def run *args
    new_command_runner.run!
    @output.string
  end
      
end