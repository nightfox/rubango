module Totango
  BASE_URI = "http://sdr.totango.com/pixel.gif/?sdr_s=".freeze unless self.const_defined?(:BASE_URI)

  class NoClientError < StandardError; end

  class << self
    attr_reader :client

    def track(data)
      raise NoClientError, "You must set the current client first" unless client
      client.track(data)
    end

    def srv_id(srv_id)
      @client = Client.new(srv_id)
    end

    def on?
      Config[:on]
    end

    def on!
      Config[:on] = true
    end
  end

  class Client
    def initialize(srv_id)
      @srv_id = srv_id
    end

    def track(data={})
      url = build_url(data)

      if Totango.on?
        if Config[:synchronous]
          make_request(url)
        else
          Thread.new { make_request(url) }
        end
      else
        unless Config[:suppress_output]
          puts "[Totango] Fake call to #{url}. To make a real call, run Totango.on!"
        end
      end
    end

    def build_url(data)
      [BASE_URI, @srv_id, "&", ArgParser.parse(data).to_params].join
    end

    def make_request(url)
      begin
        open(url)
        true
      rescue => e
        $stderr.puts "[Totango] ERROR making call to Totango: #{e.class} ~> #{e.message}"
        false
      end
    end
  end
end

