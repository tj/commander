
module Commander
	class Manager
				
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
			@info[:help_generator] ||= Commander::HelpGenerators::Default
			init_version
			at_exit { run }
		end
		
		def add_command(command)
			@commands ||= {} and @commands[command.command] = command
		end
		
		def get_command(command)
			@commands[command.to_sym]
		end
		
		def execute_command
		  abort "Invalid command." if not @user_command
		  @user_command.invoke(:when_called_proc, @user_args) 
		end
		
		def valid_command?(command)
			!@commands[command.to_sym].nil? unless command.nil?
		end
		alias :include? :valid_command?
		
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
				
		def init_version
		  raise "Your program must have a version tuple ('x.x.x')." unless valid_version?(@info[:version])
		  @info[:major], @info[:minor], @info[:tiny] = parse_version(@info[:version])
		end
		
		def run
		  abort "Invalid arguments." if @user_args.empty?
		  @command_options[:help] = true and @user_args.shift if @user_args[0] == 'help'
		  set_user_command
	    case 
        when (@command_options[:help] and @user_args.empty?) then output_help
        when @command_options[:help] then output_help
        else execute_command
      end
		end
		
		def set_user_command
		  @user_command = get_command(@user_args[0]) unless @user_args.empty?
		  @user_args.shift
		end
		
		def output_help
		  @info[:help_generator].new self
		end
	end
end