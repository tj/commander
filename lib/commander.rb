
$:.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'highline/import'
require 'commander/version'
require 'commander/core_ext'
require 'commander/runner'
require 'commander/command'
require 'commander/help_formatters'
require 'commander/import'

$command_runner = Commander::Runner.new

# Auto-execute command runner.
at_exit { $command_runner.run! rescue nil } 