
require 'rubygems'
require 'lightr'

def example file
  File.read "assets/examples/#{file}"
end

def highlight file, type
  case type
  when :ruby ; Lightr::Ruby.parse(example(file))
  else
  end
end

def title title, subheading
  %(<h1>#{title} <em>#{subheading}</em></h1>)
end

def project_url username, project
  "http://github.com/#{username}/#{project}"
end

PROJECT_URL = project_url('visionmedia', 'commander')
