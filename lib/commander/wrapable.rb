
module Wrapable
  
  ##
  # Wrap _methods_ with _position_ which may be :before_and_after,
  # :before, or :after, executing _block_ with the original arguments
  # passed to each method.
  
  def wrap(methods, position = :before_and_after, &block)
    [*methods].each do |meth|
      old = method meth
      define_method meth do |*args|
        block.call *args if [:before_and_after, :before].include? position
        old.call *args
        block.call *args if [:before_and_after, :after].include? position
      end
    end
  end
  
  ##
  # Execute _block_ before _methods_ are called.
  
  def before(*methods, &block)
    wrap methods, :before, &block
  end
  
  ##
  # Execute _block_ after _methods_ are called.
  
  def after(*methods, &block)
    wrap methods, :after, &block
  end
end