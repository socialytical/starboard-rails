module Starboard
  class Event
    attr_accessor :attributes
    
    def initialize(attributes = {})
      attributes ||= {}
      attributes.symbolize_keys!
      @attributes = attributes.merge(:occurred_at => Time.now.utc.to_i)
    end
    
    def valid?
      attributes.keys.include?(:name) and
        attributes.keys.include?(:user) and
        attributes.keys.include?(:occurred_at)
    end
    
    def to_post
      {
        "user%5Did%5D" => attributes[:user],
        "event%5Dname%5D" => attributes[:name],
        "event%5Doccurred_at%5D" => attributes[:occurred_at]
      }
    end
    
    class << self
      def create(attributes = {})
        Queue.instance.enqueue(new(attributes))
      end
    end
  end
end