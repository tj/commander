
class Array 
  
  ##
  # Split +string+ into an array. 
  #
  # === Highline example:
  #  
  #   # ask invokes Array#parse
  #   list = ask 'Favorite cookies:', Array
  #
  
  def self.parse string
    string.split
  end
  
  ##
  # Delete switches such as -h or --help.
  
  def delete_switches
    self.dup.delete_if { |v| v.to_s =~ /^-/ } 
  end
  
end