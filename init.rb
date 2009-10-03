require File.join(File.dirname(__FILE__), 'lib', 'starboard')

source = File.join(Rails.root, 'config', 'starboard.yml')

if File.exist?(source)
  configuration = YAML.load_file(source)
  configuration = configuration[Rails.env].merge(
    :application_key => configuration['application_key']
  ) if configuration
  
  if configuration
    Starboard::Configuration.configure(configuration)
    
    if Starboard::Configuration.valid?
      Starboard::Worker.start if Starboard::Configuration.enabled?
    else
      STDERR.puts %{
        We couldn't find part of the configuration required
        to run starboard analytics. Please make sure that your
        configuration for #{Rails.env} contains the properties
        'site_address', 'application_key' and 'enabled'.
        
        Starboard analytics are disabled.
      }
    end
  else
    STDERR.puts %{
      We couldn't find a starboard configuration for
      your #{Rails.env} rails environment. Make
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