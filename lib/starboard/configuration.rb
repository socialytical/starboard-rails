module Starboard
  class Configuration
    class << self
      attr_accessor :configuration
      
      def configure(configuration = {})
        configuration.symbolize_keys!
        @configuration = configuration
      end
      
      def site_address
        configuration[:site_address]
      end
      
      def application_key
        configuration[:application_key]
      end
      
      def enabled?
        configuration[:enabled]
      end
      
      def valid?
        configuration.key?(:application_key) and
          not configuration[:application_key].blank?
          configuration.key?(:enabled)
      end
    end
  end
end