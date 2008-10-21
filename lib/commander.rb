
$:.unshift(File.expand_path(File.dirname(__FILE__)))

module Commander
  MAJOR = 1
  MINOR = 0
  TINY = 0
  VERSION = [MAJOR, MINOR, TINY].join('.')
end

class Object
  include Commander
end

require 'commander/commander'

