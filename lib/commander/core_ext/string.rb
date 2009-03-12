
class String
    
  ##
  # Replace +hash+ keys with associated values.
  
  def tokenize! hash = {}
    hash.each { |key, value| gsub! /:#{key}/, value.to_s }
    self
  end
    
  ##
  # Replace +hash+ keys with associated values.
  
  def tokenize hash = {}
    self.dup.tokenize! hash
  end
  
end