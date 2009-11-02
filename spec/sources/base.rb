require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Starboard::Sources::Base do
  it "should parse a direct request" do
    @params = {}
    @request = mock("request", :referer => nil)
    
    source = Starboard::Sources::Base.new(@params, @request.referer)
    source.source.should == 'Direct'
    source.referrer.should == nil
    source.query.should == nil
  end
  
  it "should parse a request with custom source param and no referrer" do
    @params = {:source => 'June Email v1'}
    @request = mock("request", :referer => nil)
    
    source = Starboard::Sources::Base.new(@params, @request.referer)
    source.source.should == 'June Email v1'
    source.referrer.should == nil
    source.query.should == nil
  end

  it "should parse a request with custom source param and a referrer" do
    @params = {:source => 'Blog'}
    @request = mock("request", 
      :referer => 'http://myblog.blogger.com/posts/20091031/my-post')
    
    source = Starboard::Sources::Base.new(@params, @request.referer)
    source.source.should == 'Blog'
    source.referrer.should == 'myblog.blogger.com/posts/20091031/my-post'
    source.query.should == nil
  end

  it "should parse a request from google" do
    @params = {}
    @request = mock("request", 
      :referer => 'http://www.google.com?q=rails')
    
    source = Starboard::Sources::Base.new(@params, @request.referer)
    source.source.should == 'Google'
    source.referrer.should == nil
    source.query.should == 'rails'
  end

  it "should parse a request from yahoo" do
    @params = {}
    @request = mock("request", 
      :referer => 'http://search.yahoo.com?p=rails')
    
    source = Starboard::Sources::Base.new(@params, @request.referer)
    source.source.should == 'Yahoo'
    source.referrer.should == nil
    source.query.should == 'rails'
  end

  it "should parse a request from bing" do
    @params = {}
    @request = mock("request", 
      :referer => 'http://www.bing.com?q=rails')
    
    source = Starboard::Sources::Base.new(@params, @request.referer)
    source.source.should == 'Bing'
    source.referrer.should == nil
    source.query.should == 'rails'
  end

  it "should parse a catch all request from blogger" do
    @params = {}
    @request = mock("request", 
      :referer => 'http://someblog.blogger.com/posts/1')
    
    source = Starboard::Sources::Base.new(@params, @request.referer)
    source.source.should == 'someblog.blogger.com/posts/1'
    source.referrer.should == nil
    source.query.should == nil
  end
  
  it "should serialize to a hash" do
    @params = {}
    @request = mock("request", 
      :referer => 'http://someblog.blogger.com/posts/1')
    
    source = Starboard::Sources::Base.new(@params, @request.referer).to_hash
    source[:source].should == 'someblog.blogger.com/posts/1'
    source[:referrer].should == nil
    source[:query].should == nil
    
    @params = {:source => 'Blog'}
    @request = mock("request", 
      :referer => 'http://myblog.blogger.com/posts/20091031/my-post')
    
    source = Starboard::Sources::Base.new(@params, @request.referer).to_hash
    source[:source].should == 'Blog'
    source[:referrer].should == 'myblog.blogger.com/posts/20091031/my-post'
    source[:query].should == nil
    
    @params = {}
    @request = mock("request", 
      :referer => 'http://www.google.com?q=rails')
    
    source = Starboard::Sources::Base.new(@params, @request.referer).to_hash
    source[:source].should == 'Google'
    source[:referrer].should == nil
    source[:query].should == 'rails'
  end
  
  it "should serialize to yaml" do
    @params = {}
    @request = mock("request", 
      :referer => 'http://someblog.blogger.com/posts/1')
    
    source = YAML.load(Starboard::Sources::Base.new(@params, @request.referer).to_yaml)
    source[:source].should == 'someblog.blogger.com/posts/1'
    source[:referrer].should == nil
    source[:query].should == nil
    
    @params = {:source => 'Blog'}
    @request = mock("request", 
      :referer => 'http://myblog.blogger.com/posts/20091031/my-post')
    
    source = YAML.load(Starboard::Sources::Base.new(@params, @request.referer).to_yaml)
    source[:source].should == 'Blog'
    source[:referrer].should == 'myblog.blogger.com/posts/20091031/my-post'
    source[:query].should == nil
    
    @params = {}
    @request = mock("request", 
      :referer => 'http://www.google.com?q=rails')
    
    source = YAML.load(Starboard::Sources::Base.new(@params, @request.referer).to_yaml)
    source[:source].should == 'Google'
    source[:referrer].should == nil
    source[:query].should == 'rails'
  end
end