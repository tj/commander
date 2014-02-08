require 'spec_helper'

describe Commander::Command do
  
  before :each do
    mock_terminal
    create_test_command
  end
  
  describe 'Options' do
    before :each do
      @options = Commander::Command::Options.new  
    end
    
    it "should act like an open struct" do
      @options.send = 'mail'
      @options.call = true
      @options.send.should eq('mail')
      @options.call.should eq(true)
    end
    
    it "should allow __send__ to function as always" do
      @options.send = 'foo'
      @options.__send__(:send).should eq('foo')
    end
  end
  
  describe "#option" do
    it "should add options" do
      lambda { @command.option '--recursive' }.should change(@command.options, :length).from(1).to(2)
    end
    
    it "should allow procs as option handlers" do
      @command.option('--recursive') { |recursive| recursive.should be_true }
      @command.run '--recursive'
    end
    
    it "should allow usage of common method names" do
      @command.option '--open file'
      @command.when_called { |_, options| options.open.should eq('foo') }  
      @command.run '--open', 'foo'
    end
  end
  
  describe "#run" do
    describe "should invoke #when_called" do
      it "with arguments seperated from options" do
        @command.when_called { |args, options| args.join(' ').should eq('just some args') }  
        @command.run '--verbose', 'just', 'some', 'args'
      end
      
      it "calling the #call method by default when an object is called" do
        object = double 'Object'
        object.should_receive(:call).once
        @command.when_called object
        @command.run 'foo'        
      end
      
      it "should allow #action as an alias to #when_called" do
        object = double 'Object'
        object.should_receive(:call).once
        @command.action object
        @command.run 'foo'
      end
            
      it "calling an arbitrary method when an object is called" do
        object = double 'Object'
        object.should_receive(:foo).once
        @command.when_called object, :foo
        @command.run 'foo'        
      end
      
      it "should raise an error when no handler is present" do
        lambda { @command.when_called }.should raise_error(ArgumentError)
      end
    end
    
    describe "should populate options with" do
      it "boolean values" do
        @command.option '--[no-]toggle'
        @command.when_called { |_, options| options.toggle.should be_true }  
        @command.run '--toggle'
        @command.when_called { |_, options| options.toggle.should be_false }  
        @command.run '--no-toggle'
      end

      it "mandatory arguments" do
        @command.option '--file FILE'
        @command.when_called { |_, options| options.file.should eq('foo') }  
        @command.run '--file', 'foo'
        lambda { @command.run '--file' }.should raise_error(OptionParser::MissingArgument)
      end

      describe "optional arguments" do
        before do
          @command.option '--use-config [file] '
        end

        it "should return the argument when provided" do
          @command.when_called { |_, options| options.use_config.should eq('foo') }
          @command.run '--use-config', 'foo'
        end

        it "should return true when present without an argument" do
          @command.when_called { |_, options| options.use_config.should be_true }
          @command.run '--use-config'
        end

        it "should return nil when not present" do
          @command.when_called { |_, options| options.use_config.should be_nil }
          @command.run
        end
      end

      describe "typed arguments" do
        before do
          @command.option '--interval N', Integer
        end

        it "should parse valid values" do
          @command.when_called { |_, options| options.interval.should eq(5) }
          @command.run '--interval', '5'
        end

        it "should reject invalid values" do
          lambda { @command.run '--interval', 'invalid' }.should raise_error(OptionParser::InvalidArgument)
        end
      end

      it "lists" do
        @command.option '--fav COLORS', Array
        @command.when_called { |_, options| options.fav.should eq(['red', 'green', 'blue']) }  
        @command.run '--fav', 'red,green,blue'
      end
      
      it "lists with multi-word items" do
        @command.option '--fav MOVIES', Array
        @command.when_called { |_, options| options.fav.should eq(['super\ bad', 'nightmare']) }  
        @command.run '--fav', 'super\ bad,nightmare'        
      end
      
      it "defaults" do
        @command.option '--files LIST', Array
        @command.option '--interval N', Integer
        @command.when_called do |_, options|
          options.default \
            :files => ['foo', 'bar'],
            :interval => 5
          options.files.should eq(['foo', 'bar'])
          options.interval.should eq(15)
        end
        @command.run '--interval', '15'
      end
    end
  end
  
end
