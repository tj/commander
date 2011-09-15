# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "commander"
  s.version = "4.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk", "Gabriel Gilder"]
  s.date = "2011-09-15"
  s.description = "The complete solution for Ruby command-line executables"
  s.email = "ggilder@tractionco.com"
  s.executables = ["commander"]
  s.extra_rdoc_files = ["README.rdoc", "bin/commander", "lib/commander.rb", "lib/commander/blank.rb", "lib/commander/command.rb", "lib/commander/core_ext.rb", "lib/commander/core_ext/array.rb", "lib/commander/core_ext/object.rb", "lib/commander/delegates.rb", "lib/commander/help_formatters.rb", "lib/commander/help_formatters/base.rb", "lib/commander/help_formatters/terminal.rb", "lib/commander/help_formatters/terminal/command_help.erb", "lib/commander/help_formatters/terminal/help.erb", "lib/commander/help_formatters/terminal_compact.rb", "lib/commander/help_formatters/terminal_compact/command_help.erb", "lib/commander/help_formatters/terminal_compact/help.erb", "lib/commander/import.rb", "lib/commander/platform.rb", "lib/commander/runner.rb", "lib/commander/user_interaction.rb", "lib/commander/version.rb", "tasks/dev_setup.rake", "tasks/docs.rake", "tasks/gemspec.rake"]
  s.files = ["DEVELOPMENT", "History.rdoc", "Manifest", "README.rdoc", "Rakefile", "bin/commander", "commander.gemspec", "lib/commander.rb", "lib/commander/blank.rb", "lib/commander/command.rb", "lib/commander/core_ext.rb", "lib/commander/core_ext/array.rb", "lib/commander/core_ext/object.rb", "lib/commander/delegates.rb", "lib/commander/help_formatters.rb", "lib/commander/help_formatters/base.rb", "lib/commander/help_formatters/terminal.rb", "lib/commander/help_formatters/terminal/command_help.erb", "lib/commander/help_formatters/terminal/help.erb", "lib/commander/help_formatters/terminal_compact.rb", "lib/commander/help_formatters/terminal_compact/command_help.erb", "lib/commander/help_formatters/terminal_compact/help.erb", "lib/commander/import.rb", "lib/commander/platform.rb", "lib/commander/runner.rb", "lib/commander/user_interaction.rb", "lib/commander/version.rb", "spec/command_spec.rb", "spec/core_ext/array_spec.rb", "spec/core_ext/object_spec.rb", "spec/help_formatters/terminal_spec.rb", "spec/runner_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/ui_spec.rb", "tasks/dev_setup.rake", "tasks/docs.rake", "tasks/gemspec.rake"]
  s.homepage = "http://visionmedia.github.com/commander"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Commander", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "commander"
  s.rubygems_version = "1.8.10"
  s.summary = "The complete solution for Ruby command-line executables"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, ["~> 1.5.0"])
      s.add_development_dependency(%q<echoe>, ["~> 4.0.0"])
      s.add_development_dependency(%q<sdoc>, ["~> 0.3.11"])
      s.add_development_dependency(%q<rspec>, ["< 2"])
    else
      s.add_dependency(%q<highline>, ["~> 1.5.0"])
      s.add_dependency(%q<echoe>, ["~> 4.0.0"])
      s.add_dependency(%q<sdoc>, ["~> 0.3.11"])
      s.add_dependency(%q<rspec>, ["< 2"])
    end
  else
    s.add_dependency(%q<highline>, ["~> 1.5.0"])
    s.add_dependency(%q<echoe>, ["~> 4.0.0"])
    s.add_dependency(%q<sdoc>, ["~> 0.3.11"])
    s.add_dependency(%q<rspec>, ["< 2"])
  end
end
