# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{commander}
  s.version = "2.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk"]
  s.date = %q{2008-12-09}
  s.default_executable = %q{commander}
  s.description = %q{}
  s.email = ["tj@vision-media.ca"]
  s.executables = ["commander"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt", "Todo.txt"]
  s.files = [".gitignore", "History.txt", "Manifest.txt", "README.txt", "Rakefile", "Todo.txt", "bin/commander", "commander.gemspec", "lib/commander.rb", "lib/commander/command.rb", "lib/commander/core_ext.rb", "lib/commander/core_ext/array.rb", "lib/commander/core_ext/enumerable.rb", "lib/commander/core_ext/kernel.rb", "lib/commander/core_ext/object.rb", "lib/commander/core_ext/string.rb", "lib/commander/fileutils.rb", "lib/commander/help_formatters.rb", "lib/commander/help_formatters/base.rb", "lib/commander/help_formatters/terminal.rb", "lib/commander/help_formatters/terminal/command_help.erb", "lib/commander/help_formatters/terminal/help.erb", "lib/commander/import.rb", "lib/commander/runner.rb", "lib/commander/user_interaction.rb", "lib/commander/version.rb", "spec/all_spec.rb", "spec/commander_spec.rb", "spec/help_formatter_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{The complete solution for Ruby command-line executables. }
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{commander}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
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
