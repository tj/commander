
def create_test_command
  command :test do |c|
    c.syntax = "test [options] <file>"
    c.description = "test description"
    c.example "description", "code"
    c.option("-t", "--trace") {}
    c.option("-v", "--verbose") {}
    c.when_called do |args|
      "test %s" % args.join
    end
  end
end

def new_command_runner(*args)
  $command_runner = Commander::Runner.new $stdin, $stdout, args
  create_test_command
end
