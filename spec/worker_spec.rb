require File.join(File.dirname(__FILE__), 'spec_helper')

describe Starboard::Worker do
  before(:each) do
    @queue = Starboard::Queue.instance
    @queue.clear
  end
  
  it "should initialize with queue" do
    lambda{Starboard::Worker.new(@queue)}.should_not raise_error
  end
  
  it "should process one message" do    
    message = mock("message")
    message.should_receive(:valid?).and_return(true)
    
    @queue.enqueue(message)
    
    @worker = Starboard::Worker.new(@queue)
    @worker.should_receive(:record).and_return(true)
    @worker.should_receive(:sleep).with(5)
    
    @worker.process_one
  end
  
  it "should slow down if recording wasn't successful" do
    message = mock("message")
    message.should_receive(:valid?).and_return(true)
    
    @queue.enqueue(message)
    
    @worker = Starboard::Worker.new(@queue)
    @worker.should_receive(:record).and_return(false)
    @worker.should_receive(:sleep).with(2 * 0.5)
    
    @worker.process_one
  end
  
  it "should go faster if the queue is longer" do
    message = mock("message")
    message.should_receive(:valid?).and_return(true)
    
    @queue.enqueue(message)
    @queue.stub(:length).and_return(10)
    
    @worker = Starboard::Worker.new(@queue)
    @worker.should_receive(:record).with(message).and_return(true)
    @worker.should_receive(:sleep).with(0.10 * 0.5)
    
    @worker.process_one
  end
  
  it "should break the loop if stopped" do
    @worker = Starboard::Worker.new(@queue)
    @worker.stop
    @worker.process
  end
  
  it "should record a message" do
    address = mock("address")
    message = mock("message", :to_post => {})
    Net::HTTP.should_receive(:post_form).with(address, {})
    
    @worker = Starboard::Worker.new(@queue)
    
    @worker.record(message)
  end
end