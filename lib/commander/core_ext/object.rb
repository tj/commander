
class Object
  
  include Commander::UserInteraction
  
  ##
  # Used with ERB in Commander::HelpFormatter::Base.
  
  def get_binding
    binding
  end
end