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
      {
        "user[id]" => attributes[:user],
        "event[name]" => attributes[:name],
        "event[occurred_at]" => attributes[:occurred_at]
      }
    end
    
    class << self
      def create(attributes = {})
        Queue.instance.enqueue(new(attributes)) if Starboard::Configuration.enabled?
      end
    end
  end
end