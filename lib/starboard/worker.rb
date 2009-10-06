module Starboard
  class Worker
    attr_accessor :queue
    attr_accessor :stopped
    attr_accessor :wait_weight
    
    def initialize(queue)
      @queue = queue
      @stopped = false
      @wait_weight = 1
    end
    
    def stop
      @stopped = true
    end
    
    def cleanup
      if Starboard::Configuration.debug?
        puts "[Starboard] => Analytics services stopped."
      end
    end
    
    def process      
      loop do
        (queue.length == 0 and stopped) ? break : process_one
      end
    end
    
    def process_one
      if queue.length > 0
        
        message = queue.dequeue
        begin
          if message.valid?
            if record(message)
              @wait_weight = 1              
            else
              @wait_weight *= 2
              queue.enqueue(message)
            end
          end
        rescue
          @wait_weight *= 2
          queue.enqueue(message)
        end
        
        if queue.length == 0
          sleep 5
        else
          sleep((1 / queue.length.to_f) * @wait_weight * 0.5)
        end
      else
        sleep 5
      end
    end
    
    def record(message)
      host = "api.starboardhq.com"
      application_key = Starboard::Configuration.application_key
      address = "http://#{host}/applikations/#{application_key}/events"
      recorded = Net::HTTP.post_form(URI.parse(address), message.to_post)
    end
    
    class << self
      attr_accessor :worker
      attr_accessor :worker_thread
      
      def start        
        if @worker_thread
          @worker_thread.start
        else
          @worker = new(Queue.instance)
          
          if defined?(PhusionPassenger)
            PhusionPassenger.on_event(:starting_worker_process) do |forked|
              if forked
                @worker_thread ||= spawn
              else
                @worker_thread ||= spawn
              end
            end
          else            
            @worker_thread ||= spawn
          end
        end
      end
      
      def spawn
        Thread.new do
          if Starboard::Configuration.debug?
            puts "[Starboard] => Analytics services started."
          end
          
          begin
            @worker.process
          ensure
            @worker.cleanup                
          end
        end
      end
      
      def stop
        worker.stop
        worker.cleanup
        worker_thread.stop
      end
    end
  end
end