
$:.unshift(File.expand_path(File.dirname(__FILE__)))

require 'commander/commander'

class Object
  include Commander
end

