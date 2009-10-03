require File.join(File.dirname(__FILE__), 'lib', 'starboard')


# read configuration
source = File.join(Rails.root, 'config', 'starboard.yml')

if File.exist?(source)
  configuration = YAML.load_file(source)
  configuration = configuration[Rails.env]
  
  puts configuration
  
  if configuration
    configuration = Starboard::Configuration.configure(configuration)
    Starboard::Worker.start if configuration.enabled?
  else
    STDERR.puts %{
      We couldn't find a starboard configuration for
      your the rails environment #{Rails.env}, make
      sure you're config/starboard.yml file contains your
      application configuration. You can find your configuration
      by signing into your starboard account.
      
      Starboard analytics are disabled.
    }
  end
else
  STDERR.puts %{
    We couldn't find your starboard configuration file, 
    make sure you have one at config/starboard.yml.
    You can find your application configuration by signing
    into your starboard account.
    
    Starboard analytics are disabled.
  }
end