# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{commander}
  s.version = "2.5.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk"]
  s.date = %q{2009-03-11}
  s.default_executable = %q{commander}
  s.description = %q{The complete solution for Ruby command-line executables}
  s.email = %q{tj@vision-media.ca}
  s.executables = ["commander"]
  s.extra_rdoc_files = ["bin/commander", "lib/commander/command.rb", "lib/commander/core_ext/array.rb", "lib/commander/core_ext/kernel.rb", "lib/commander/core_ext/object.rb", "lib/commander/core_ext/string.rb", "lib/commander/core_ext.rb", "lib/commander/fileutils.rb", "lib/commander/help_formatters/base.rb", "lib/commander/help_formatters/terminal/command_help.erb", "lib/commander/help_formatters/terminal/help.erb", "lib/commander/help_formatters/terminal.rb", "lib/commander/help_formatters.rb", "lib/commander/import.rb", "lib/commander/runner.rb", "lib/commander/user_interaction.rb", "lib/commander/version.rb", "lib/commander.rb", "README.rdoc", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake"]
  s.files = ["bin/commander", "commander.gemspec", "History.rdoc", "lib/commander/command.rb", "lib/commander/core_ext/array.rb", "lib/commander/core_ext/kernel.rb", "lib/commander/core_ext/object.rb", "lib/commander/core_ext/string.rb", "lib/commander/core_ext.rb", "lib/commander/fileutils.rb", "lib/commander/help_formatters/base.rb", "lib/commander/help_formatters/terminal/command_help.erb", "lib/commander/help_formatters/terminal/help.erb", "lib/commander/help_formatters/terminal.rb", "lib/commander/help_formatters.rb", "lib/commander/import.rb", "lib/commander/runner.rb", "lib/commander/user_interaction.rb", "lib/commander/version.rb", "lib/commander.rb", "Manifest", "Rakefile", "README.rdoc", "spec/commander_spec.rb", "spec/core_ext/string_spec.rb", "spec/help_formatter_spec.rb", "spec/import_spec.rb", "spec/spec_helper.rb", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake", "Todo.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/visionmedia/commander}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Commander", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{commander}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The complete solution for Ruby command-line executables}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 1.5.0"])
    else
      s.add_dependency(%q<highline>, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.5.0"])
  end
end
