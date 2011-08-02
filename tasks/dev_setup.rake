desc 'Install development dependencies'
task :dev_setup do
  ObjectSpace.each_object(Echoe) do |o|
    o.development_dependencies.each do |gem_string|
      gem_name, version = gem_string.split(' ', 2)
      cmd = "gem install #{gem_name}"
      cmd += " --version '#{version}'" if (version)
      puts `#{cmd}`
    end
  end
end