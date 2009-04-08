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

# Enable paging of output after this point
enable_paging

# Ask editor for input (EDITOR or TextMate by default)
ask_editor

# Ask editor, supplying initial text
ask_editor 'previous data to update'

# Display a generic Growl notification
notify 'Something happened'

# Display an 'info' status notification
notify_info 'You have #{emails.length} new email(s)'

# Display an 'ok' status notification
notify_ok 'Gems updated'

# Display a 'warning' status notification 
notify_warning '1 gem failed installation'

# Display an 'error' status notification
notify_error "Gem #{name} failed"
