
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
    
    LOG_FORMAT = "%8s  %s"
    
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
    # be incremented:
    #
    #    uris = %w[ 
    #      http://vision-media.ca
    #      http://yahoo.com
    #      http://google.com
    #      ]
    #
    #    bar = Commander::UI::ProgressBar.new uris.length, options
    #    threads = []
    #    uris.each do |uri|
    #      threads << Thread.new do
    #        begin
    #          res = open uri
    #          bar.inc :uri => uri
    #        rescue Exception => e
    #          bar.inc :uri => "#{uri} failed"
    #        end
    #      end
    #    end
    #    threads.each { |t| t.join }
    #
    # The Kernel method #progress is also available, below are
    # single and multi-threaded examples:
    #
    #    progress uris, :width => 10 do |uri|
    #      res = open uri
    #    end
    #    
    #    threads = uris.collect { |uri| Thread.new { res = open uri } } 
    #    progress threads, :progress_char => '-' do |thread|
    #      thread.join
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
      #    :progress_char      Progress character, defaults to "="
      #    :incomplete_char    Incomplete bar character, defaults to '.'
      #    :format             Defaults to ":title |:progress_bar| :percent_complete% complete "
      #    :tokens             Additional tokens replaced within the format string
      #    :complete_message   Defaults to "Process complete"
      #
      # === Tokens:
      #
      #    :title 
      #    :percent_complete
      #    :progress_bar
      #    :current
      #    :remaining
      #    :total
      #    :output
      #    :time_elapsed
      #    :time_remaining
      #

      def initialize total, options = {}
        @total, @options, @current, @start = total, options, 0, Time.now
        @options = {
          :title => "Progress",
          :width => 25,
          :progress_char => "=",
          :incomplete_char => ".",
          :complete_message => "Process complete",
          :format => ":title |:progress_bar| :percent_complete% complete ",
          :output => $stderr, 
          :tokens => {},
        }.merge! options
        show
      end

      ##
      # Output the progress bar.

      def show
        unless @current >= (@total + 1)
          erase_line
          percent = (@current * 100) / @total
          elapsed = Time.now - @start
          remaining = @total - @current
          tokens = {
            :title => @options[:title],
            :percent_complete => percent,
            :progress_bar => (@options[:progress_char] * (@options[:width] * percent / 100)).ljust(@options[:width], @options[:incomplete_char]), 
            :current => @current,
            :remaining => remaining,
            :total => @total, 
            :time_elapsed => "%0.2fs" % [elapsed],
            :time_remaining => "%0.2fs" % [(elapsed / @current) * remaining],
          }.merge! @options[:tokens]
          if completed?
            @options[:output].print @options[:complete_message].tokenize(tokens) << "\n" if @options[:complete_message].is_a? String
          else
            @options[:output].print @options[:format].tokenize(tokens)
          end
        end
      end

      ##
      # Weither or not the operation has completed.

      def completed?
        @current == @total
      end
      alias :finished? :completed?

      ##
      # Increment progress. Optionally pass _tokens_ which
      # can be displayed in the output format.

      def increment tokens = {}
        @current += 1
        @options[:tokens].merge! tokens if tokens.is_a? Hash
        show
      end
      alias :inc :increment

      ##
      # Erase previous terminal line.

      def erase_line
        @options[:output].print "\r\e[K"
      end

      ##
      # Output progress while iterating _enum_.
      #
      # === Example:
      #
      #    uris = %[ http://vision-media.ca http://google.com ]
      #    ProgressBar.progress uris, :format => "Remaining: :time_remaining" do |uri|
      #      res = open uri
      #    end
      #
      # === See:
      #
      # * Kernel#progress

      def self.progress enum, options = {}, &block
        threads = []
        bar = ProgressBar.new enum.length, options
        enum.each { |v| bar.inc yield(v) } 
      end
    end
  end
end