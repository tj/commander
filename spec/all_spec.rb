
require File.expand_path(File.dirname(__FILE__) + '/../lib/commander')
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

Dir['./spec/**/*.rb'].each do |file|
  require file unless file == './spec/all_spec.rb'
end