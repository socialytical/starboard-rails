require File.join(File.dirname(__FILE__), 'spec_helper')

describe Starboard::Event do
  before(:each) do
    Starboard::Configuration.configure(:enabled => true)
  end
  
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
  
  it "should serialize a simple event" do
    to_post = Starboard::Event.new(:name => 'event', :user => 'user').to_post

    to_post["event[name]"].should == 'event'
    to_post["user[id]"].should == 'user'
    to_post.keys.include?("event[occurred_at]").should == true
  end
  
  it "should serialize an event with custom attributes" do
    to_post = Starboard::Event.new(
      :name => 'event', :outcome => 'success', :retries => '5',
      :user => {:id => '1', :company => 'Socialytical'}
    ).to_post
    
    to_post["event[name]"].should == 'event'
    to_post["event[outcome]"].should == 'success'
    to_post["event[retries]"].should == '5'
    to_post["user[id]"].should == '1'
    to_post["user[company]"].should == 'Socialytical'
  end
  
  it "should serialize with a nested user" do
    to_post = Starboard::Event.new(
      :name => 'event', :user => {:id => '1', :company => 'Socialytical'}
    ).to_post
    
    to_post["event[name]"].should == 'event'
    to_post["user[id]"].should == '1'
    to_post["user[company]"].should == 'Socialytical'
  end
  
  it "should serialize with measures" do
    to_post = Starboard::Event.new(
      :name => 'event', 
      :user => {:id => '1', :company => 'Socialytical'},
      :measures => {:amount => 100.5, :tax => 50.50}
    ).to_post
    
    to_post["event[name]"].should == 'event'
    to_post["user[id]"].should == '1'
    to_post["user[company]"].should == 'Socialytical'
    to_post["measures[amount]"].should == 100.5
    to_post["measures[tax]"].should == 50.50
  end
end