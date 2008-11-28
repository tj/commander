
class Object
  
  include Commander::UI
  
  ##
  # Used with ERB in Commander::HelpFormatter::Base.
  
  def get_binding
    binding
  end
end