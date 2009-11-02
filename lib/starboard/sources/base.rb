#
# Utility class for source tracking
#

require 'uri'

module Starboard
  module Sources
    class Base
      attr_accessor :source
      attr_accessor :referrer
      attr_accessor :query
      
      def initialize(params, referrer = nil)
        if referrer
          uri = URI.parse(referrer)
          
          if params[:source]
            @source = params[:source]
            @referrer = uri.host + uri.path
          elsif uri.host == 'www.google.com'
            @source = 'Google'
            @query = extract_property(uri.query, 'q')
          elsif uri.host == 'www.bing.com'
            @source = 'Bing'
            @query = extract_property(uri.query, 'q')
          elsif uri.host == 'search.yahoo.com'
            @source = 'Yahoo'
            @query = extract_property(uri.query, 'p')
          else
            @source = uri.host + uri.path
          end
        elsif params[:source]
          # a source without a referrer (some email clients)
          @source = params[:source]
        else
          @source = 'Direct'
        end
      end
      
      def extract_property(query, name)
        query.match(/#{name}=([^&]+)/)[1] unless query.nil? or name.nil?
      end

      def to_hash
        {:source => source, :referrer => referrer, :query => query}
      end
      
      def to_yaml
        YAML.dump(to_hash)
      end
      
      def to_s
        to_hash.to_s
      end
      
      def inspect
        to_hash.inspect
      end
    end
  end
end