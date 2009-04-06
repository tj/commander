
desc 'Build docs with sdoc gem'
task :docs do
  sh 'sdoc -N lib/commander'
end

namespace :docs do
  
  desc 'Remove rdoc products'
  task :remove => [:clobber_docs]
  
  desc 'Build docs, and open in browser for viewing (specify BROWSER)'
  task :open => [:docs] do
    browser = ENV["BROWSER"] || "safari"
    sh "open -a #{browser} doc/index.html"
  end
  
end