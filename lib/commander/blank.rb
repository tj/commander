
module Blank
  def self.included base
    base.class_eval do
      instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    end
  end
end