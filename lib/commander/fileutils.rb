
require 'fileutils'

module VerboseFileUtils
  
  include FileUtils
  
  ##
  # Wrap _methods_ with _action_ log message.
    
  def self.log action, *methods
    methods.each do |meth|
      # FIXME: get Commander::UI.log working from VerboseFileUtils
      define_method meth do |*args|
        Commander::UI.log "#{action}", *args
        super
      end
    end
  end
  
  log "remove", :rm, :rm_r, :rm_rf, :rmdir
  log "create", :touch, :mkdir, :mkdir_p
  log "copy", :cp, :cp_r
  log "move", :mv
  log "change", :cd
  log "link", :ln, :ln_s
  log "install", :install

end

include VerboseFileUtils
