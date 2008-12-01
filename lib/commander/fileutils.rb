
require 'fileutils'

module FileUtils
  
  extend Wrapable
  
  after :rm, :rm_r, :rm_rf, :rmdir do |*args|
    Commander::UI.log "remove", *args
  end
  
  after :touch, :cp, :cp_r, :mkdir, :mkdir_p do |*args|
    Commander::UI.log "create", *args
  end
  
  after :mv do |src, dest, options|
    Commander::UI.log "remove", src, options
    Commander::UI.log "create", dest, options
  end
  
  after :cd do |*args|
    Commander::UI.log "change", *args
  end
  
  after :ln, :ln_s do |*args|
    Commander::UI.log "link", *args
  end
  
  after :install do |*args|
    Commander::U.log "install", *args
  end
end

include FileUtils
