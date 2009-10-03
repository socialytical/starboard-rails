require File.join(File.dirname(__FILE__), 'spec_helper')

describe Starboard::Queue do
  before(:each) do
    @queue = Starboard::Queue.instance
    @queue.clear
  end
  
  it "should act like a singleton" do
    @queue.should == Starboard::Queue.instance
  end
  
  it "should enqueue a message" do
    @queue.length.should == 0
    @queue.enqueue('message')
    @queue.length.should == 1
  end
  
  it "should dequeue a message" do
    @queue.length.should == 0
    @queue.enqueue('message')
    @queue.length.should == 1
    message = @queue.dequeue
    message.should == 'message'
    @queue.length.should == 0
  end
end