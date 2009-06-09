
module Commander
  
  ##
  # = User Interaction
  #
  # Commander's user interaction module mixes in common
  # methods which extend HighLine's functionality such 
  # as a #password method rather than calling #ask directly.
  
  module UI
    
    module_function
    
    #--
    # Auto include growl when available.
    #++
    
    begin
      require 'growl'
    rescue LoadError
      # Do nothing
    else
      include Growl
    end
    
    ##
    # Ask the user for a password. Specify a custom
    # _message_ other than 'Password: ' or override the 
    # default _mask_ of '*'.
    
    def password message = 'Password: ', mask = '*'
      pass = ask(message) { |q| q.echo = mask }
      pass = password message, mask if pass.nil? || pass.empty?
      pass
    end
    
    ##
    # Choose from a set array of _choices_.
    
    def choose message, *choices
      say message
      super *choices
    end
    
    ##
    # 'Log' an _action_ to the terminal. This is typically used
    # for verbose output regarding actions performed. For example:
    #
    #   create  path/to/file.rb
    #   remove  path/to/old_file.rb
    #   remove  path/to/old_file2.rb
    #
    
    def log action, *args
      say '%15s  %s' % [action, args.join(' ')]
    end
    
    ##
    # Speak _message_ using _voice_ which defaults
    # to 'Alex', which is one of the better voices.
    #
    # === Examples
    #    
    #   speak 'What is your favorite food? '
    #   food = ask 'favorite food?: '
    #   speak "wow, I like #{food} too. We have so much alike." 
    #
    # === Notes
    #
    # * MacOS only
    #
    
    def speak message, voice = :Alex
      Thread.new { applescript "say #{message.inspect} using #{voice.to_s.inspect}" }
    end
    
    ##
    # Converse with speech recognition. 
    #
    # Currently a "poorman's" DSL to utilize applescript and
    # the MacOS speech recognition server.
    #
    # === Examples
    #
    #   case converse 'What is the best food?', :cookies => 'Cookies', :unknown => 'Nothing'
    #   when :cookies 
    #     speak 'o.m.g. you are awesome!'
    #   else
    #     case converse 'That is lame, shall I convince you cookies are the best?', :yes => 'Ok', :no => 'No', :maybe => 'Maybe another time'
    #     when :yes
    #       speak 'Well you see, cookies are just fantastic.'
    #     else
    #       speak 'Ok then, bye.'
    #     end
    #   end
    #
    # === Notes
    #
    # * MacOS only
    #
    
    def converse prompt, responses = {}
      i, commands = 0, responses.map { |key, value| value.inspect }.join(',')
      statement = responses.inject '' do |statement, (key, value)|
        statement << (((i += 1) == 1 ? 
          %(if response is "#{value}" then\n):
            %(else if response is "#{value}" then\n))) <<
              %(do shell script "echo '#{key}'"\n)
      end
      applescript(%(
        tell application "SpeechRecognitionServer" 
          set response to listen for {#{commands}} with prompt "#{prompt}"
          #{statement}
          end if
        end tell
      )).strip.to_sym
    end
    
    ##
    # Execute apple _script_.
    
    def applescript script
      `osascript -e "#{ script.gsub('"', '\"') }"`
    end
    
    ##
    # Normalize IO streams, allowing for redirection of
    # +input+ and/or +output+, for example:
    #
    #   $ foo              # => read from terminal I/O
    #   $ foo in           # => read from 'in' file, output to terminal output stream
    #   $ foo in out       # => read from 'in' file, output to 'out' file
    #   $ foo < in > out   # => equivalent to above (essentially)
    #
    # Optionally a +block+ may be supplied, in which case
    # IO will be reset once the block has executed.
    #
    # === Examples
    #
    #   command :foo do |c|
    #     c.syntax = 'foo [input] [output]'
    #     c.when_called do |args, options|
    #       # or io(args.shift, args.shift)
    #       io *args
    #       str = $stdin.gets
    #       puts 'input was: ' + str.inspect
    #     end
    #   end
    #
    
    def io input = nil, output = nil, &block
      $stdin = File.new(input) if input
      $stdout = File.new(output, 'r+') if output
      if block
        yield
        reset_io
      end
    end
    
    ##
    # Reset IO to initial constant streams.
    
    def reset_io
      $stdin, $stdout = STDIN, STDOUT
    end
    
    ##
    # Prompt _editor_ for input. Optionally supply initial
    # _input_ which is written to the editor.
    #
    # The _editor_ defaults to the EDITOR environment variable
    # when present, or 'mate' for TextMate. 
    #
    # === Examples
    #
    #   ask_editor                # => prompts EDITOR with no input
    #   ask_editor('foo')         # => prompts EDITOR with default text of 'foo'
    #   ask_editor('foo', :mate)  # => prompts TextMate with default text of 'foo'
    #
       
    def ask_editor input = nil, editor = ENV['EDITOR'] || 'mate'
      IO.popen(editor.to_s, 'w+') do |pipe|
        pipe.puts input.to_s unless input.nil?
        pipe.close_write
        pipe.read
      end
    end
    
    ##
    # Enable paging of output after called.
    
    def enable_paging
      return unless $stdout.tty?
      read, write = IO.pipe

      if Kernel.fork
        $stdin.reopen read
        read.close; write.close
        Kernel.select [$stdin]
        ENV['LESS'] = 'FSRX'
        pager = ENV['PAGER'] || 'less'
        exec pager rescue exec '/bin/sh', '-c', pager
      else
        $stdout.reopen write
        $stderr.reopen write if $stderr.tty?
        read.close; write.close
        return
      end
    end
    
    ##
    # Output progress while iterating _arr_.
    #
    # === Examples
    #
    #   uris = %w( http://vision-media.ca http://google.com )
    #   progress uris, :format => "Remaining: :time_remaining" do |uri|
    #     res = open uri
    #   end
    #

    def progress arr, options = {}, &block
      bar = ProgressBar.new arr.length, options
      arr.each { |v| bar.increment yield(v) }
    end
        
    ##
    # Implements ask_for_CLASS methods.
    
    module AskForClass
      def method_missing meth, *args, &block
        case meth.to_s
        when /^ask_for_([\w]+)/ ; $terminal.ask(args.first, Kernel.const_get($1.capitalize))
        else super
        end
      end
    end
    
    ##
    # Substitute _hash_'s keys with their associated values in _str_.
    
    def replace_tokens str, hash #:nodoc:
      hash.inject str do |str, (key, value)|
        str.gsub ":#{key}", value.to_s
      end
    end
    
    ##
    # = Progress Bar
    #
    # Terminal progress bar utility. In its most basic form
    # requires that the developer specifies when the bar should
    # be incremented. Note that a hash of tokens may be passed to
    # #increment, (or returned when using Object#progress).
    #
    #   uris = %w( 
    #     http://vision-media.ca
    #     http://yahoo.com
    #     http://google.com
    #     )
    #   
    #   bar = Commander::UI::ProgressBar.new uris.length, options
    #   threads = []
    #   uris.each do |uri|
    #     threads << Thread.new do
    #       begin
    #         res = open uri
    #         bar.increment :uri => uri
    #       rescue Exception => e
    #         bar.increment :uri => "#{uri} failed"
    #       end
    #     end
    #   end
    #   threads.each { |t| t.join }
    #
    # The Object method #progress is also available:
    #
    #   progress uris, :width => 10 do |uri|
    #     res = open uri
    #     { :uri => uri } # Can now use :uri within :format option
    #   end
    #

    class ProgressBar

      ##
      # Creates a new progress bar.
      #
      # === Options
      #    
      #   :title              Title, defaults to "Progress"
      #   :width              Width of :progress_bar
      #   :progress_str       Progress string, defaults to "="
      #   :incomplete_str     Incomplete bar string, defaults to '.'
      #   :format             Defaults to ":title |:progress_bar| :percent_complete% complete "
      #   :tokens             Additional tokens replaced within the format string
      #   :complete_message   Defaults to "Process complete"
      #
      # === Tokens
      #
      #   :title 
      #   :percent_complete
      #   :progress_bar
      #   :step
      #   :steps_remaining
      #   :total_steps
      #   :time_elapsed
      #   :time_remaining
      #

      def initialize total, options = {}
        @total_steps, @step, @start_time = total, 0, Time.now
        @title = options.fetch :title, 'Progress'
        @width = options.fetch :width, 25
        @progress_str = options.fetch :progress_str, '='
        @incomplete_str = options.fetch :incomplete_str, '.'
        @complete_message = options.fetch :complete_message, 'Process complete'
        @format = options.fetch :format, ':title |:progress_bar| :percent_complete% complete '
        @tokens = options.fetch :tokens, {}
      end
      
      ##
      # Completion percentage.
      
      def percent_complete
        @step * 100 / @total_steps
      end
      
      ##
      # Time that has elapsed since the operation started.
      
      def time_elapsed
        Time.now - @start_time
      end
      
      ##
      # Estimated time remaining.
      
      def time_remaining
        (time_elapsed / @step) * steps_remaining
      end
      
      ##
      # Number of steps left.
      
      def steps_remaining
        @total_steps - @step
      end
      
      ##
      # Formatted progress bar.
      
      def progress_bar
        (@progress_str * (@width * percent_complete / 100)).ljust @width, @incomplete_str
      end
      
      ##
      # Generates tokens for this step.
      
      def generate_tokens
        {
          :title => @title,
          :percent_complete => percent_complete,
          :progress_bar => progress_bar, 
          :step => @step,
          :steps_remaining => steps_remaining,
          :total_steps => @total_steps, 
          :time_elapsed => "%0.2fs" % time_elapsed,
          :time_remaining => "%0.2fs" % time_remaining,
        }.
        merge! @tokens
      end

      ##
      # Output the progress bar.

      def show
        unless finished?
          erase_line
          if completed?
            $terminal.say UI.replace_tokens(@complete_message, generate_tokens) if @complete_message.is_a? String
          else
            $terminal.say UI.replace_tokens(@format, generate_tokens) << ' '
          end
        end
      end
      
      ##
      # Whether or not the operation is complete, and we have finished.
      
      def finished?
        @step == @total_steps + 1
      end

      ##
      # Whether or not the operation has completed.

      def completed?
        @step == @total_steps
      end

      ##
      # Increment progress. Optionally pass _tokens_ which
      # can be displayed in the output format.

      def increment tokens = {}
        @step += 1
        @tokens.merge! tokens if tokens.is_a? Hash
        show
      end

      ##
      # Erase previous terminal line.

      def erase_line
        # highline does not expose the output stream
        $terminal.instance_variable_get('@output').print "\r\e[K"
      end
    end
  end
end
