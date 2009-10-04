namespace :starboard do
  desc "Verify that your starboard plugin settings are correct"
  task :check => [:environment] do
    puts "\nChecking #{Rails.env} configuration for starboard analytics..."
    puts Starboard::Configuration.check
  end 
end