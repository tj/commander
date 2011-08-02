
$:.unshift 'lib'
require 'commander'
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new "commander", Commander::VERSION do |p|
  p.email = "ggilder@tractionco.com"
  p.summary = "The complete solution for Ruby command-line executables"
  p.url = "http://visionmedia.github.com/commander"
  p.runtime_dependencies << "highline >=1.5.0"
  p.development_dependencies << "echoe >=4.0.0"
  p.development_dependencies << "sdoc >=0.2.20"
  p.development_dependencies << "rspec <2"
  
  p.eval = Proc.new do
    self.authors = ["TJ Holowaychuk", "Gabriel Gilder"]
    self.default_executable = "commander"
  end
end

Dir['tasks/**/*.rake'].sort.each { |lib| load lib }
