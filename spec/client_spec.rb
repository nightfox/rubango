require File.expand_path('../spec_helper', __FILE__)

describe SaasPulse::Client do
  before do
    @client = SaasPulse::Client.new("lolwut")
  end

  it "builds a valid url when sent correct data" do
    valid_url  = "http://sdr.saaspulse.com/pixel.gif/?sdr_s=lolwut"\
                 "&sdr_a=fake+activity&sdr_o=legit+organization"\
                 "&sdr_m=awesome+module&sdr_u=annoying+user"

    @client.build_url({
      :sdr_a => "fake activity",
      :sdr_o => "legit organization",
      :sdr_m => "awesome module",
      :sdr_u => "annoying user"
    }).should eql(valid_url)
  end

  it "doesn't allow wrong params sent" do
    lambda do
      @client.build_url :this_should_bomb => "fingers crossed"
    end.should raise_error(SaasPulse::InvalidParamError)
  end

  describe "param aliases" do
    it {@client.build_url(:a => "activity").should match(/sdr_a=activity/)}
    it {@client.build_url(:act => "activity").should match(/sdr_a=activity/)}
    it {@client.build_url(:activity => "activity").should match(/sdr_a=activity/)}

    it {@client.build_url(:o => "org").should match(/sdr_o=org/)}
    it {@client.build_url(:org => "org").should match(/sdr_o=org/)}
    it {@client.build_url(:organization => "org").should match(/sdr_o=org/)}

    it {@client.build_url(:m => "mod").should match(/sdr_m=mod/)}
    it {@client.build_url(:mod => "mod").should match(/sdr_m=mod/)}
    it {@client.build_url(:module => "mod").should match(/sdr_m=mod/)}

    it {@client.build_url(:u => "user").should match(/sdr_u=user/)}
    it {@client.build_url(:user => "user").should match(/sdr_u=user/)}
  end

  describe "Tracking" do
    before { SaasPulse.instance_variable_set(:@client, nil) }

    it "requires a client to be set" do
      lambda {SaasPulse.track(:fake => "data")}.should raise_error(SaasPulse::NoClientError)
    end
  end
end

