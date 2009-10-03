if File.directory?('config')
  source = File.join(File.dirname(__FILE__), 'starboard.yml')
  destination = File.join(File.join('config', 'starboard.yml'))
  
  if File.exist?(destination)
    puts %{
      We found a starboard.yml configuration file in your config 
      directory, you can find your application configuration by 
      signing into your starboard account.
    }
  else
    FileUtils.cp(source, destination)
    
    puts %{
      We added a default starboard.yml file to config/starboard.yml, 
      you can find your application configuration by signing into your 
      starboard account.
      
      If you don't have a starboard account already, getting started
      is easy, just visit http://www.starboardhq.com/ and sign up. With
      an account and this plugin you'll be tracking your application
      analytics in no time.
    }
  end
else
  STDERR.puts %{
    We couldn't find your rails config directory, please make sure it 
    exists and try installing this plugin again.
  }
end