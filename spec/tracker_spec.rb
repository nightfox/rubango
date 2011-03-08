require File.expand_path "../spec_helper", __FILE__

describe Totango::Tracker do
  context "when not sent an action" do
    it "fails miserably" do
      lambda{Totango::Tracker.new}.should raise_error(ArgumentError)
    end
  end

  context "when sent an action" do
    before do
      @tracker = Totango::Tracker.new :index
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
      Totango::Tracker.new(:index, "activity text").opts[:activity].should eql("activity text")
    end

    it "allows sending opts without activity text" do
      Totango::Tracker.new(:index, :user => "lolwut", :module => "hrm").opts.keys.map(&:to_s).sort.should eql(%w(module user))
    end

    it "allows sending activity text and options" do
      t = Totango::Tracker.new :index, "hello", :user => "lolwut"
      t.opts[:activity].should eql("hello")
      t.opts[:user].should eql("lolwut")
    end
  end
end

