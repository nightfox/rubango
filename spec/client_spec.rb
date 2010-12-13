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
    context "when no client has been set" do
      before { SaasPulse.instance_variable_set(:@client, nil) }

      it "raises NoClientError" do
        lambda {SaasPulse.track(:fake => "data")}.should raise_error(SaasPulse::NoClientError)
      end
    end

    context "when client has been set" do
      before do
        SaasPulse.srv_id "lolwut"
      end

      context "when not turned on" do
        let(:io_stream) {"/tmp/__sp_spec_tmp_stream"}

        before do
          SaasPulse::Config[:on] = false
          @_stdout = $stdout
          $stdout = File.open(io_stream, "w")
        end

        after do
          $stdout = @_stdout
        end

        context "when not suppressing output" do
          before do
            SaasPulse::Config[:suppress_output] = false
            SaasPulse.track :a => "hello thar"
            $stdout.close
          end

          it "prints a debug message" do
            File.read(io_stream).chomp.should match(/^\[SaasPulse\] Fake call to/)
          end
        end

        context "when suppressing output" do
          before do
            SaasPulse::Config[:suppress_output] = true
            SaasPulse.track :a => "hello thar"
            $stdout.close
          end

          it "prints nothing" do
            File.read(io_stream).chomp.should be_empty
          end
        end
      end
    end

    it "prints a debug message instead of making the remote call if not turned on" do

    end
  end
end

