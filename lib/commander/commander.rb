
require 'commander/version'
require 'commander/interaction'
require 'commander/command'
require 'commander/manager'
require 'commander/help_generators'
require 'optparse'

module Commander
  	
	def init_commander(options = {})
		Commander::Manager.instance options
	end
	
	def add_command(command, &block)
		_command = command
		command = Commander::Command.new(_command)
		yield command if block_given?
		Commander::Manager.instance.add_command command
	end
	alias :command :add_command
	
	def get_command(command)
		Commander::Manager.instance.get_command command
	end
	
	def command_exists?(command)
		Commander::Manager.instance.include? command
	end
	
	def info(option)
		Commander::Manager.instance.info[option]
	end
end

