require File.expand_path "../spec_helper", __FILE__

describe SaasPulse::Tracker do
  it "requires an action" do
    lambda{SaasPulse::Tracker.new}.should raise_error(ArgumentError)
  end

  context "when sent an action" do
    before do
      @tracker = SaasPulse::Tracker.new :index
    end

    it "doesn't require an activity" do
      @tracker.opts[:activity].should be_nil
    end

    it "doesn't require opts" do
      @tracker.opts.should eql({})
    end
  end

  context "When sent other opts" do
    it "allows setting activity text as second arg" do
      SaasPulse::Tracker.new(:index, "activity text").opts[:activity].should eql("activity text")
    end

    it "allows sending opts without activity text" do
      SaasPulse::Tracker.new(:index, :user => "lolwut", :module => "hrm").opts.keys.map(&:to_s).sort.should eql(%w(module user))
    end

    it "allows sending activity text and options" do
      t = SaasPulse::Tracker.new :index, "hello", :user => "lolwut"
      t.opts[:activity].should eql("hello")
      t.opts[:user].should eql("lolwut")
    end
  end
end

