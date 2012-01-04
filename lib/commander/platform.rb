require 'rbconfig'

module Commander
  module Platform
    def self.jruby?
      defined?(RUBY_ENGINE) && (RUBY_ENGINE == 'jruby')
    end

    def self.win?
      RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
    end
  end
end
