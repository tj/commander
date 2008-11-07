
Gem::Specification.new do |s|
  s.name = %q{commander}
  s.version = "1.2.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk"]
  s.date = %q{2008-11-06}
  s.default_executable = %q{commander}
  s.description = %q{Commander is a small framework for creating a sub-command utility. For example a sub command would be 'git add' or 'git rm', where 'add' and 'rm' are sub commands.}
  s.email = ["tj@vision-media.ca"]
  s.executables = ["commander"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/commander", "lib/commander.rb", "lib/commander/command.rb", "lib/commander/commander.rb", "lib/commander/help_generators.rb", "lib/commander/help_generators/default.rb", "lib/commander/manager.rb", "lib/commander/version.rb", "spec/all_spec.rb", "spec/commander_spec.rb", "spec/manager_spec.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{commander}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Commander is a small framework for creating a sub-command utility}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<highline>, [">= 1.5.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<highline>, [">= 1.5.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.5.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end


