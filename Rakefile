$:.unshift 'lib'

require 'psych'
require 'rubygems'

load_errors = ['highline', 'echoe'].map do |g|
  begin
    require g
    nil
  rescue LoadError
    "The #{g} gem is not installed. Please run:\n\tgem install #{g}"
  end
end.compact
abort "Missing dependencies!\n" + load_errors.join("\n") unless load_errors.empty?

require 'commander'
require 'rake'

Echoe.new "commander", Commander::VERSION do |p|
  p.email = "ggilder@tractionco.com"
  p.summary = "The complete solution for Ruby command-line executables"
  p.url = "http://visionmedia.github.com/commander"
  p.runtime_dependencies << "highline >=1.5.0"
  p.development_dependencies << "echoe >=4.0.0"
  p.development_dependencies << "sdoc >=0.2.20"
  p.development_dependencies << "rspec ~>1.3"
  
  p.eval = Proc.new do
    self.authors = ["TJ Holowaychuk", "Gabriel Gilder"]
    self.default_executable = "commander"
  end
end

Dir['tasks/**/*.rake'].sort.each { |lib| load lib }
