require File.expand_path('../spec_helper', __FILE__)

describe Totango::Client do
  before do
    @client = Totango::Client.new("lolwut")
  end

  it "builds a valid url when sent correct data" do
    valid_url  = "http://sdr.totango.com/pixel.gif/?sdr_s=lolwut"\
                 "&sdr_a=fake+activity&sdr_o=legit+organization"\
                 "&sdr_m=awesome+module&sdr_u=annoying+user"\
                 "&sdr_ofid=1234"

    @client.build_url({
      :sdr_a => "fake activity",
      :sdr_o => "legit organization",
      :sdr_m => "awesome module",
      :sdr_u => "annoying user",
      :sdr_ofid => "1234"
    }).should eql(valid_url)
  end

  it "doesn't allow wrong params sent" do
    lambda do
      @client.build_url :this_should_bomb => "fingers crossed"
    end.should raise_error(Totango::InvalidParamError)
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

    it {@client.build_url(:ofid => "org").should match(/sdr_ofid=org/)}
    it {@client.build_url(:organization_foreign_id => "org").should match(/sdr_ofid=org/)}
  end

  describe "Tracking" do
    context "when no client has been set" do
      before { Totango.instance_variable_set(:@client, nil) }

      it "raises NoClientError" do
        lambda {Totango.track(:fake => "data")}.should raise_error(Totango::NoClientError)
      end
    end

    context "when client has been set" do
      before do
        Totango.srv_id "lolwut"
      end

      context "when not turned on" do
        before do
          Totango::Config[:on] = false
          @_stdout = $stdout
          @string_io = StringIO.new
          $stdout = @string_io
        end

        after do
          $stdout = @_stdout
        end

        context "when not suppressing output" do
          before do
            Totango::Config[:suppress_output] = false
            Totango.track :a => "hello thar"
          end

          it "prints a debug message" do
            @string_io.string.should match(/^\[Totango\] Fake call to/)
          end
        end

        context "when suppressing output" do
          before do
            Totango::Config[:suppress_output] = true
            Totango.track :a => "hello thar"
          end

          it "prints nothing" do
            @string_io.string.should be_empty
          end
        end
      end

      context "when turned on" do
        before do
          Totango::Config[:on] = true
        end

        describe "successful request" do
          before do
            OpenURI.stub!(:open_uri).and_return true
          end

          context "when using synchronous requests" do
            before do
              Totango::Config[:synchronous] = true
            end

            it "doesn't create a new thread" do
              Thread.should_receive(:new).never
              Totango.track :a => "hello thar"
            end
          end

          context "when using asynchronous requests" do
            before do
              Totango::Config[:synchronous] = false
            end

            it "creates a new thread" do
              Thread.should_receive(:new).once
              Totango.track :a => "hello thar"
            end
          end
        end

        describe "failed request" do
          before do
            Totango::Config[:synchronous] = true
            Totango::Config[:suppress_output] = true
            OpenURI.stub!(:open_uri).and_raise SocketError.new("network lulz")
          end

          before :all do
            @_stderr    = $stderr
            @stdcapture = StringIO.new
            $stderr     = @stdcapture
          end

          after(:all) {$stderr = @_stderr}

          specify "the tracking request returns false" do
            Totango.track(:a => "hello thar").should_not be
          end

          it "logs the error to stderr" do
            errmsg = "[Totango] ERROR making call to Totango: SocketError ~> network lulz\n"
            @stdcapture.string.should eql(errmsg)
          end
        end
      end
    end
  end
end

