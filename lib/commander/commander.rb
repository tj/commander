
require 'commander/command'

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
	
	def get_command(command)
		Commander::Manager.instance.get_command command
	end
	
	def command_exists?(command)
		Commander::Manager.instance.include? command
	end
	
	def get_option(option)
		Commander::Manager.instance.options[option]
	end
end

module Commander
	class Manager
		
		include Enumerable
		
		attr_accessor :options

		def self.instance(options = {})
			@@instance ||= Commander::Manager.new options
		end
		
		def initialize(options)
			@options = options
			parse_options
		end
		
		def add_command(command)
			@commands ||= {} and @commands[command.command] = command
		end
		
		def get_command(command)
			@commands[command]
		end
		
		def each
			@commands.each { |command| yield command }	
		end
		
		def include?(command)
			!@commands[command].nil?
		end
		
		def empty?
			@commands.empty?
		end
		
		def length
			@commands.length
		end
		alias :size :length
		
		# -----------------------------------------------------------

			private

		# -----------------------------------------------------------
		
		def parse_options
			raise ArgumentError.new('Specify a version for your program in the format of \'0.0.0\'.') unless valid_version @options[:version]
			@options[:major], @options[:minor], @options[:tiny] = @options[:version].split('.').collect { |v| v.to_i } 
		end
		
		def valid_version(version)
			version.split('.').length == 3
		end
	end
end