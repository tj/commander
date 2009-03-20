
$:.unshift 'lib'
require 'commander'
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new "commander", Commander::VERSION do |p|
  p.author = "TJ Holowaychuk"
  p.email = "tj@vision-media.ca"
  p.summary = "The complete solution for Ruby command-line executables"
  p.url = "http://visionmedia.github.com/commander"
  p.runtime_dependencies << "highline >=1.5.0"
end

Dir['tasks/**/*.rake'].sort.each { |lib| load lib }
