
module Commander
	class Manager
		
		include Enumerable
		
		attr_reader :options, :option_parser, :commands, :info
		attr_reader :user_command, :user_args
		
		def self.instance(options = {})
			@@instance ||= Commander::Manager.new options
		end
		
		def initialize(options)
			@info, @options = options, {}
			@user_args = @options[:argv] || ARGV.dup
			init_version
			#at_exit { run_command }
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
		
		def valid_version?(version)
			version.split('.').length == 3
		end
		
		def parse_version(version)
		  version.split('.').collect { |v| v.to_i } 
		end
		
		def debug_abort(msg, exception = nil)
		  abort msg
		end
		
		# -----------------------------------------------------------

		  protected

		# -----------------------------------------------------------
		
		def init_version
		  @info[:major], @info[:minor], @info[:tiny] = parse_version(@info[:version]) if valid_version?(@info[:version])
		end
	end
end