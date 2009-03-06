
module Commander
  
  ##
  # = User Interaction
  #
  # Commander's user interacton module mixes in common
  # methods which extend HighLine's functionality such 
  # as a unified +password+ method rather than calling
  # +ask+ directly.
  
  module UI
    
    ##
    # Format used within #log.
    
    LOG_FORMAT = "%15s  %s"
    
    ##
    # Ask the user for a password. Specify a custom
    # _msg_ other than 'Password: ' or override the 
    # default +mask+ of '*'.
    
    def password msg = "Password: ", mask = '*'
      pass = ask(msg) { |q| q.echo = mask }
      pass = password msg, mask if pass.empty?
      pass
    end
    
    ##
    # 'Log' an _action_ to the terminal. This is typically used
    # for verbose output regarding actions performed. For example:
    #
    #   create  path/to/file.rb
    #   remove  path/to/old_file.rb
    #   remove  path/to/old_file2.rb
    #
    # To alter this format simply change the Commander::UI::LOG_FORMAT
    # constant to whatever you like.
    
    def log action, *args
      say LOG_FORMAT % [action, args.join(' ')]
    end
    
    ##
    # = Progress Bar
    #
    # Terminal progress bar utility. In its most basic form
    # requires that the developer specifies when the bar should
    # be incremented. Note that a hash of tokens may be passed to
    # #increment, (or returned when using Kernel#progress).
    #
    #    uris = %w( 
    #      http://vision-media.ca
    #      http://yahoo.com
    #      http://google.com
    #      )
    #
    #    bar = Commander::UI::ProgressBar.new uris.length, options
    #    threads = []
    #    uris.each do |uri|
    #      threads << Thread.new do
    #        begin
    #          res = open uri
    #          bar.increment :uri => uri
    #        rescue Exception => e
    #          bar.increment :uri => "#{uri} failed"
    #        end
    #      end
    #    end
    #    threads.each { |t| t.join }
    #
    # The Kernel method #progress is also available:
    #
    #    progress uris, :width => 10 do |uri|
    #      res = open uri
    #    end
    #

    class ProgressBar

      ##
      # Creates a new progress bar.
      #
      # === Options:
      #    
      #    :title              Title, defaults to "Progress"
      #    :width              Width of :progress_bar
      #    :progress_str       Progress string, defaults to "="
      #    :incomplete_str     Incomplete bar string, defaults to '.'
      #    :format             Defaults to ":title |:progress_bar| :percent_complete% complete "
      #    :tokens             Additional tokens replaced within the format string
      #    :complete_message   Defaults to "Process complete"
      #
      # === Tokens:
      #
      #    :title 
      #    :percent_complete
      #    :progress_bar
      #    :step
      #    :steps_remaining
      #    :total_steps
      #    :time_elapsed
      #    :time_remaining
      #

      def initialize total, options = {}
        @total_steps, @step, @start_time = total, 0, Time.now
        @title = options.fetch :title, 'Progress'
        @width = options.fetch :title, 25
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
      # Output the progress bar.

      def show
        unless finished?
          erase_line
          tokens = {
            :title => @title,
            :percent_complete => percent_complete,
            :progress_bar => progress_bar, 
            :step => @step,
            :steps_remaining => steps_remaining,
            :total_steps => @total_steps, 
            :time_elapsed => "%0.2fs" % time_elapsed,
            :time_remaining => "%0.2fs" % time_remaining,
          }.merge! @tokens
          if completed?
            print @complete_message.tokenize(tokens) << "\n" if @complete_message.is_a? String
          else
            print @format.tokenize(tokens)
          end
        end
      end
      
      ##
      # Weither or not the operation is complete, and we have finished.
      
      def finished?
        @steps >= (@total_steps + 1)
      end

      ##
      # Weither or not the operation has completed.

      def completed?
        @step == @total_steps
      end
      alias :finished? :completed?

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
        print "\r\e[K"
      end

      ##
      # Output progress while iterating _arr_.
      #
      # === Example:
      #
      #    uris = %w( http://vision-media.ca http://google.com )
      #    ProgressBar.progress uris, :format => "Remaining: :time_remaining" do |uri|
      #      res = open uri
      #    end
      #
      # === See:
      #
      # * Kernel#progress

      def self.progress arr, options = {}, &block
        bar = ProgressBar.new arr.length, options
        arr.each { |v| bar.increment yield(v) } 
      end
      
    end
  end
end