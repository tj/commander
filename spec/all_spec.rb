
Dir['./spec/**/*.rb'].each do |file|
  require file unless file == './spec/all_spec.rb'
end