
require File.expand_path(File.dirname(__FILE__) + '/../lib/commander')

$halt_commander = true

Dir['./spec/**/*.rb'].each do |file|
  require file unless file == './spec/all_spec.rb'
end