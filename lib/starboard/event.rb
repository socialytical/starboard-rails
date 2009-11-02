module Starboard
  class Event
    attr_accessor :attributes
    
    def initialize(attributes = {})
      attributes ||= {}
      attributes.symbolize_keys!
      @attributes = attributes.merge(:occurred_at => Time.now.utc.to_i)
    end
    
    def valid?
      attributes.key?(:name) and
        attributes.key?(:user) and
        attributes.key?(:occurred_at)
    end
    
    def to_post
      post = {}
      user = attributes.delete(:user)
      measures = attributes.delete(:measures)
      event = attributes
      
      if user.is_a?(Hash)
        user.each do |key, value|
          post["user[#{key}]"] = value
        end
      else
        post['user[id]'] = user
      end
      
      if measures.is_a?(Hash)
        measures.each do |key, value|
          post["measures[#{key}]"] = value
        end
      end
      
      if event.is_a?(Hash)
        event.each do |key, value|
          post["event[#{key}]"] = value
        end
      end
      
      post
    end
    
    class << self
      def create(attributes = {})
        if Starboard::Configuration.debug?
          Rails.logger.info("[Starboard] => Recording event with #{attributes.inspect}")
        end
        
        Queue.instance.enqueue(new(attributes)) if Starboard::Configuration.enabled?
      end
    end
  end
end