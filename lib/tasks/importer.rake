require 'readline'
task :bootstrap_database do
  username = Readline.readline("Enter Username: ")
  database = Readline.readline("Enter DB Name: ")
  command = ["mysql", "-u#{username}"]
  command << '-p'
  command << database
  system "#{command.join(" ")} < db/schema.sql"
end
