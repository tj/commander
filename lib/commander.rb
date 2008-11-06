
$:.unshift(File.expand_path(File.dirname(__FILE__)))

require 'commander/commander'
require 'highline/import'
 
class Object
  include Commander
end