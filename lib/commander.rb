
$:.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'highline/import'
require 'commander/version'
require 'commander/runner'
require 'commander/command'
require 'commander/help_formatters'
require 'commander/import'

unless $halt_commander
  $command_runner = Commander::Runner.new
  $command_runner.run
end