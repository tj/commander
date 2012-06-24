require 'spec_helper'

describe Array do

  describe "#parse" do
    it "should seperate a list of words into an array" do
      Array.parse('just a test').should eq(['just', 'a', 'test'])
    end

    it "should preserve escaped whitespace" do
      Array.parse('just a\ test').should eq(['just', 'a test'])
    end

    it "should match %w behavior with multiple backslashes" do
      str = 'just a\\ test'
      Array.parse(str).should eq(eval("%w(#{str})"))
    end
  end

end
