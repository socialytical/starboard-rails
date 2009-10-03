require File.join(File.dirname(__FILE__), 'spec_helper')

describe Starboard::Event do
  it "should initialize with attribute" do
    lambda { Starboard::Event.new(:attr => 'this') }.should_not raise_error
  end
  
  it "should initialize without attributes" do
    lambda { Starboard::Event.new }.should_not raise_error
  end
  
  it "should initialize with nil attributes" do 
    lambda { Starboard::Event.new(nil) }.should_not raise_error
  end
  
  it "shouldn't be valid without an event name" do
    event = Starboard::Event.new(:user => 'fake')
    event.valid?.should == false
  end
  
  it "shouldn't be valid without a user id" do
    event = Starboard::Event.new(:name => 'event')
    event.valid?.should == false
  end
  
  it "should be valid with an event name and user id" do
    event = Starboard::Event.new(:name => 'event', :user => 'user')
    event.valid?.should == true
  end
  
  it "should enqueue an event on create" do
    event = mock("event")
    Starboard::Event.should_receive(:new).with(:attributes).and_return(event)
    
    queue = mock("queue")
    queue.should_receive(:enqueue).with(event)
    Starboard::Queue.should_receive(:instance).and_return(queue)
    
    Starboard::Event.create(:attributes)
  end
  
  it "should serialize for posting" do
    to_post = Starboard::Event.new(:name => 'event', :user => 'user').to_post
    
    to_post["event%5Dname%5D"].should == 'event'
    to_post["user%5Did%5D"].should == 'user'
    to_post.keys.include?("event%5Doccurred_at%5D").should == true
  end
end