# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{commander}
  s.version = "4.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{TJ Holowaychuk}, %q{Gabriel Gilder}]
  s.date = %q{2011-08-09}
  s.description = %q{The complete solution for Ruby command-line executables}
  s.email = %q{ggilder@tractionco.com}
  s.executables = [%q{commander}]
  s.extra_rdoc_files = [%q{README.rdoc}, %q{bin/commander}, %q{lib/commander.rb}, %q{lib/commander/blank.rb}, %q{lib/commander/command.rb}, %q{lib/commander/core_ext.rb}, %q{lib/commander/core_ext/array.rb}, %q{lib/commander/core_ext/object.rb}, %q{lib/commander/delegates.rb}, %q{lib/commander/help_formatters.rb}, %q{lib/commander/help_formatters/base.rb}, %q{lib/commander/help_formatters/terminal.rb}, %q{lib/commander/help_formatters/terminal/command_help.erb}, %q{lib/commander/help_formatters/terminal/help.erb}, %q{lib/commander/help_formatters/terminal_compact.rb}, %q{lib/commander/help_formatters/terminal_compact/command_help.erb}, %q{lib/commander/help_formatters/terminal_compact/help.erb}, %q{lib/commander/import.rb}, %q{lib/commander/platform.rb}, %q{lib/commander/runner.rb}, %q{lib/commander/user_interaction.rb}, %q{lib/commander/version.rb}, %q{tasks/dev_setup.rake}, %q{tasks/docs.rake}, %q{tasks/gemspec.rake}]
  s.files = [%q{DEVELOPMENT}, %q{History.rdoc}, %q{Manifest}, %q{README.rdoc}, %q{Rakefile}, %q{bin/commander}, %q{commander.gemspec}, %q{lib/commander.rb}, %q{lib/commander/blank.rb}, %q{lib/commander/command.rb}, %q{lib/commander/core_ext.rb}, %q{lib/commander/core_ext/array.rb}, %q{lib/commander/core_ext/object.rb}, %q{lib/commander/delegates.rb}, %q{lib/commander/help_formatters.rb}, %q{lib/commander/help_formatters/base.rb}, %q{lib/commander/help_formatters/terminal.rb}, %q{lib/commander/help_formatters/terminal/command_help.erb}, %q{lib/commander/help_formatters/terminal/help.erb}, %q{lib/commander/help_formatters/terminal_compact.rb}, %q{lib/commander/help_formatters/terminal_compact/command_help.erb}, %q{lib/commander/help_formatters/terminal_compact/help.erb}, %q{lib/commander/import.rb}, %q{lib/commander/platform.rb}, %q{lib/commander/runner.rb}, %q{lib/commander/user_interaction.rb}, %q{lib/commander/version.rb}, %q{spec/command_spec.rb}, %q{spec/core_ext/array_spec.rb}, %q{spec/core_ext/object_spec.rb}, %q{spec/help_formatters/terminal_spec.rb}, %q{spec/runner_spec.rb}, %q{spec/spec.opts}, %q{spec/spec_helper.rb}, %q{spec/ui_spec.rb}, %q{tasks/dev_setup.rake}, %q{tasks/docs.rake}, %q{tasks/gemspec.rake}]
  s.homepage = %q{http://visionmedia.github.com/commander}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Commander}, %q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{commander}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{The complete solution for Ruby command-line executables}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 1.5.0"])
      s.add_development_dependency(%q<echoe>, [">= 4.0.0"])
      s.add_development_dependency(%q<sdoc>, [">= 0.2.20"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
    else
      s.add_dependency(%q<highline>, [">= 1.5.0"])
      s.add_dependency(%q<echoe>, [">= 4.0.0"])
      s.add_dependency(%q<sdoc>, [">= 0.2.20"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.5.0"])
    s.add_dependency(%q<echoe>, [">= 4.0.0"])
    s.add_dependency(%q<sdoc>, [">= 0.2.20"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
  end
end
