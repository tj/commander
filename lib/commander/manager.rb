
module Commander
	class Manager
		
		include Enumerable
		
		attr_reader :command_options, :commands, :info
		attr_reader :user_command, :user_args
		
		def self.instance(options = {})
			@@instance ||= Commander::Manager.new options
		end
		
		def self.kill_instance!
		  @@instance = nil
		end
		
		def initialize(options)
			@info, @command_options = options, {}
			@user_args = @info[:argv] || ARGV.dup
			init_version
			at_exit { run }
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
			version.split('.').length == 3 if version.is_a? String
		end
		
		def parse_version(version)
		  version.split('.').collect { |v| v.to_i } if version.is_a? String
		end
		
		def debug_abort(msg, exception = nil)
		  abort msg
		end
		
		def run
		  @command_options[:help] = true if @user_args[0] == 'help'
		end
				
		# -----------------------------------------------------------

		  protected

		# -----------------------------------------------------------
		
		def init_version
		  raise "Your program must have a version tuple ('x.x.x')." unless valid_version?(@info[:version])
		  @info[:major], @info[:minor], @info[:tiny] = parse_version(@info[:version])
		end
	end
end