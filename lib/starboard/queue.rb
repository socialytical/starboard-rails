module Starboard
  class Queue
    attr_accessor :queue
    attr_accessor :semaphore
    
    def initialize
      @queue = []
      @semaphore = Mutex.new
    end
    
    def dequeue
      message = nil
      semaphore.synchronize {
        message = @queue.shift
      }
      message
    end
    
    def enqueue(message)
      semaphore.synchronize {
        @queue.push(message)
      }
    end
    
    def length
      length = 0
      semaphore.synchronize {
        length = @queue.length
      }
      length
    end
    
    def empty?
      length == 0
    end
    
    def clear
      semaphore.synchronize {
        @queue.clear
      }
    end
    
    class << self
      def instance
        @@starboard_queue ||= new
      end
    end
  end
end