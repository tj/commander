
module Commander
  
  ##
  # = User Interaction
  #
  # Commander's user interacton module mixes in common
  # methods which extend HighLine's functionality such 
  # as a unified +password+ method rather than calling
  # +ask+ directly.
  
  module UserInteraction
    
    ##
    # Ask the user for a password. Specify a custom
    # +msg+ other than 'Password: ' or override the 
    # default +mask+ of '*'.
    
    def password(msg = "Password: ", mask = '*')
      ask(msg) { |q| q.echo = mask }
    end
        
  end
end