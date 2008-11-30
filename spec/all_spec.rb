
$:.unshift File.expand_path(File.dirname(__FILE__))
require 'spec_helper'

Dir['./spec/**/*.rb'].each do |file|
  require file unless file == './spec/all_spec.rb'
end