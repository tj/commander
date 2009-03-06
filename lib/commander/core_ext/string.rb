
class String
    
  ##
  # Replace +hash+ keys with associated values. Mutative.
  
  def tokenize! hash = {}
    hash.each { |k, v| gsub! /:#{k}/, v.to_s }
    self
  end
    
  ##
  # Replace +hash+ keys with associated values.
  
  def tokenize hash = {}
    self.dup.tokenize! hash
  end
  
  ##
  # Converts a string to camelcase.
  
  def camelcase upcase_first_letter = true
    up = upcase_first_letter
    s = dup
    s.gsub!(/\/(.?)/){ "::#{$1.upcase}" }
    s.gsub!(/(?:_+|-+)([a-z])/){ $1.upcase }
    s.gsub!(/(\A|\s)([a-z])/){ $1 + $2.upcase } if up
    s
  end
    
end