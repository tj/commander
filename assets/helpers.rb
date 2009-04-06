
require 'rubygems'
require 'lightr'

def example file
  File.read "assets/examples/#{file}"
end

def highlight string
  Lightr::Ruby.parse(string).to_s
end

def title title, subheading
  %(<h1>#{title} <em>#{subheading}</em></h1>)
end

def project_url username, project
  "http://github.com/#{username}/#{project}"
end

PROJECT_URL = project_url('visionmedia', 'commander')
