
module Commander
  module UserInteraction
    
    ##
    # Ask the user for a password. Specify a custom
    # +msg+ other than 'Password: ' or override the 
    # default +mask+ of '*'.
    
    def password(msg = "Password: ", mask = '*')
      ask(msg) { |q| q.echo = mask }
    end
    module_function :password
    
  end
end