
class Array 
  
  ##
  # Split +string+ into an array. 
  #
  # === Highline example:
  #  
  #   # ask invokes Array#parse
  #   list = ask 'Favorite cookies:', Array
  #
  
  def self.parse(string)
    string.split
  end
  
end