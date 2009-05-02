
class Array 
  
  ##
  # Split _string_ into an array. Used in
  # conjunction with Highline's ask, or ask_for_array
  # methods, which must respond to #parse.
  #
  # This method allows escaping of whitespace. For example
  # the arguments foo bar\ baz will become ['foo', 'bar baz']
  #
  # === Highline example
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
    
end
