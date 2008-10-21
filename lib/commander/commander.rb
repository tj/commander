
require 'commander/command'
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
	
	def get_command(command)
		Commander::Manager.instance.get_command command
	end
	
	def command_exists?(command)
		Commander::Manager.instance.include? command
	end
	
	def get_info(option)
		Commander::Manager.instance.info[option]
	end
end

module Commander
	class Manager
		
		include Enumerable
		
		attr_reader :user_command, :user_args, :options, :info

		def self.instance(options = {})
			@@instance ||= Commander::Manager.new options
		end
		
		def initialize(options)
			@info, @options = options, {}
			init_info
			at_exit { run_command }
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
		
		def run_command
		  @user_args = ARGV.dup
		  init_command
		  parse_options
		  exec_command
		end
		
		def init_info
			raise ArgumentError.new('Specify a version for your program in the format of \'0.0.0\'.') unless valid_version @info[:version]
			@info[:major], @info[:minor], @info[:tiny] = parse_version @info[:version]
		end
		
		def init_command
		  # TODO: OpenStruct so that c.options can be stored for .when_called
		  # TODO: default options --help, --version, --debug, --trace, etc
		  # TODO: default arg help COMMAND, equiv to COMMAND --help?
		  # TODO: allow subcommands to utilize debug, trace, version etc...?
		  begin
		    user_command = @user_args.shift.to_sym
		    raise "Command #{user_command} does not exist." if @commands[user_command].nil?
	    rescue => e
	      debug_abort "invalid arguments.", e
      else
        @user_command = @commands[user_command]
      end
		end
		
		def parse_options
		  begin
		    parser = OptionParser.new
		    default_options parser
		    @user_command.options.each { |option| parser.on(*option) } 
		    parser.parse! @user_args
		  rescue => e
		    abort e
	    end
		end
		
		def default_options(parser)
		  parser.on('--help', 'View this help documentation.') { puts "TODO --help" }
		  parser.on('--trace', 'View exceptions and tracing information.') { @options[:trace] = true }
		end
		
		def exec_command
		  
		end
		
		def debug_abort(msg, exception = nil)
		  p @options[:trace]
		  case @options[:trace]
	      when true then abort "#{msg}\n\nError: #{exception}\n\nTrace:#{trace}"
        else abort msg
      end
		end
		
		def valid_version(version)
			version.split('.').length == 3
		end
		
		def parse_version(version)
		  version.split('.').collect { |v| v.to_i } 
		end
	end
end