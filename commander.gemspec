# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{commander}
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk"]
  s.date = %q{2009-10-10}
  s.default_executable = %q{commander}
  s.description = %q{The complete solution for Ruby command-line executables}
  s.email = %q{tj@vision-media.ca}
  s.executables = ["commander"]
  s.extra_rdoc_files = ["README.rdoc", "bin/commander", "lib/commander.rb", "lib/commander/blank.rb", "lib/commander/command.rb", "lib/commander/core_ext.rb", "lib/commander/core_ext/array.rb", "lib/commander/core_ext/object.rb", "lib/commander/delegates.rb", "lib/commander/help_formatters.rb", "lib/commander/help_formatters/base.rb", "lib/commander/help_formatters/terminal.rb", "lib/commander/help_formatters/terminal/command_help.erb", "lib/commander/help_formatters/terminal/help.erb", "lib/commander/help_formatters/terminal_compact.rb", "lib/commander/help_formatters/terminal_compact/command_help.erb", "lib/commander/help_formatters/terminal_compact/help.erb", "lib/commander/import.rb", "lib/commander/runner.rb", "lib/commander/user_interaction.rb", "lib/commander/version.rb", "tasks/docs.rake", "tasks/gemspec.rake"]
  s.files = ["History.rdoc", "Manifest", "README.rdoc", "Rakefile", "bin/commander", "commander.gemspec", "lib/commander.rb", "lib/commander/blank.rb", "lib/commander/command.rb", "lib/commander/core_ext.rb", "lib/commander/core_ext/array.rb", "lib/commander/core_ext/object.rb", "lib/commander/delegates.rb", "lib/commander/help_formatters.rb", "lib/commander/help_formatters/base.rb", "lib/commander/help_formatters/terminal.rb", "lib/commander/help_formatters/terminal/command_help.erb", "lib/commander/help_formatters/terminal/help.erb", "lib/commander/help_formatters/terminal_compact.rb", "lib/commander/help_formatters/terminal_compact/command_help.erb", "lib/commander/help_formatters/terminal_compact/help.erb", "lib/commander/import.rb", "lib/commander/runner.rb", "lib/commander/user_interaction.rb", "lib/commander/version.rb", "spec/command_spec.rb", "spec/core_ext/array_spec.rb", "spec/core_ext/object_spec.rb", "spec/help_formatters/base_spec.rb", "spec/help_formatters/terminal_spec.rb", "spec/runner_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/ui_spec.rb", "tasks/docs.rake", "tasks/gemspec.rake"]
  s.homepage = %q{http://visionmedia.github.com/commander}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Commander", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{commander}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{The complete solution for Ruby command-line executables}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 1.5.0"])
    else
      s.add_dependency(%q<highline>, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.5.0"])
  end
end
