
module Enumerable
  
  ##
  # Remove first item matching _value_.
  
  def delete_first_match value
    deleted = false
    delete_if do |v|
      deleted = if value.is_a? Regexp
          v =~ value
        else
          v == value
        end unless deleted
    end 
  end
  
end