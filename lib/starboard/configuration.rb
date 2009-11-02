module Starboard
  class Configuration
    class << self
      attr_accessor :configuration
      
      def configure(configuration = {})
        configuration.symbolize_keys!
        @configuration = configuration
      end
      
      def configuration
        @configuration || {}
      end
      
      def application_key
        configuration[:application_key]
      end
      
      def debug?
        configuration[:debug]
      end
      
      def enabled?
        configuration[:enabled]
      end
      
      def valid?
        configuration.key?(:application_key) and
          not configuration[:application_key].blank?
          configuration.key?(:enabled)
      end
      
      def check
        host = "api.starboardhq.com"
        address = "http://#{host}/applikations/#{application_key}/check"
        Net::HTTP.get(URI.parse(address))
      end
    end
  end
end