
# TODO: remove when 1.9.x compatible, utilize BasicObject conditionally 

class BlankSlate
  instance_methods.each { |m| undef_method m unless m =~ /^__/ }
end