
class String
    
  ##
  # Replace _hash_ keys with associated values. Mutative.
  
  def tokenize!(hash)
    hash.each_pair do |k, v|
      self.gsub! Regexp.new(":#{k}"), v.to_s
    end
    self
  end
    
  ##
  # Replace _hash_ keys with associated values.
  
  def tokenize(hash)
    self.dup.tokenize! hash
  end
  
end