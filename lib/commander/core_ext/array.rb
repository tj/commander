
class Array 
  
  ##
  # Split +string+ into an array. Used in
  # conjunection with Highline's ask, or ask_for_array
  # methods, which must respond to #parse.
  #
  # === Highline example:
  #  
  #   # ask invokes Array#parse
  #   list = ask 'Favorite cookies:', Array
  #
  
  def self.parse string
    string.scan(/(?:\w|\d|\\ )+/).map{ |value| value.sub('\\', '')  }
  end
  
  ##
  # Delete switches such as -h or --help.
  
  def delete_switches
    self.dup.delete_if { |v| v.to_s =~ /^-/ } 
  end
  
end