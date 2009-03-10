# Ask for password masked with '*' character
ask("Password:  ") { |q| q.echo = "*" }

# Ask for password 
ask("Password:  ") { |q| q.echo = false }

# Ask if the user agrees (yes or no)
agree("Do something?")

# Asks on a single line (note the space after ':')
ask("Name: ")

# Asks with new line after "Description:"
ask("Description:")

# Calls Date#parse to parse the date string passed
ask("Birthday? ", Date)

# Ensures Integer is within the range specified
ask("Age? ", Integer) { |q| q.in = 0..105 }

# Asks for a list of strings, converts to array
ask("Fav colors?", Array)

# Ask for password 
password

# Ask for password with specific message and mask character
password "Enter your password please:", '-'

# Ask for CLASS, which may be any valid class responding to #parse. Date, Time, Array, etc
names = ask_for_array 'Names: '
bday = ask_for_date 'Birthday?: '

# 'Log' action to stdout
log "create", "path/to/file.rb"

# Simple progress bar (Commander::UI::ProgressBar)
uris = %w( vision-media.ca google.com yahoo.com )
progress uris do |uri|
 res = open "http://#{uri}"
 # Do something with response
end

# Provide a menu for users to choose from
choose do |menu|
  menu.index = :letter
  menu.index_suffix = ") "
  menu.prompt = "Please choose your favorite programming language?  "
  menu.choice :ruby do say("Good choice!") end
  menu.choices(:python, :perl) do say("Not from around here, are you?") end
end

# Custom shell
loop do
  choose do |menu|
    menu.layout = :menu_only
    menu.shell = true
    menu.choice(:load, "Load a file.") do |command, details|
      say("Loading file with options:  #{details}...")
    end
    menu.choice(:save, "Save a file.") do |command, details|
      say("Saving file with options:  #{details}...")
    end
    menu.choice(:quit, "Exit program.") { exit }
  end
end

