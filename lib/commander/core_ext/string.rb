
class String
    
  ##
  # Replace _hash_ keys with associated values. Mutative.
  
  def tokenize! hash
    hash.each_pair do |k, v|
      self.gsub! Regexp.new(":#{k}"), v.to_s
    end
    self
  end
    
  ##
  # Replace _hash_ keys with associated values.
  
  def tokenize hash
    self.d
    up.tokenize! hash
  end
  
  ##
  # Converts a string to camelcase.
  
  def camelcase upcase_first_letter = true
    up = upcase_first_letter
    str = dup
    str.gsub!(/\/(.?)/){ "::#{$1.upcase}" }
    str.gsub!(/(?:_+|-+)([a-z])/){ $1.upcase }
    str.gsub!(/(\A|\s)([a-z])/){ $1 + $2.upcase } if up
    str
  end
    
end