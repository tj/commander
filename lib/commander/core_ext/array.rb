
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
  #   # or use ask_for_CLASS
  #   list = ask_for_array 'Favorite cookies: '
  #
  
  def self.parse string
    eval "%w(#{string})"
  end
  
  ##
  # Delete switches such as -h or --help.
  
  def delete_switches
    self.dup.delete_if { |v| v.to_s =~ /^-/ } 
  end
  
end