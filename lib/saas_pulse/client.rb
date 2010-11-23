module SaasPulse
  BASE_URI = "http://sdr.saaspulse.com/pixel.gif/?sdr_s=".freeze unless self.const_defined?(:BASE_URI)

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
  end

  class Client
    def initialize(srv_id)
      @srv_id = srv_id
    end

    def track(data={})
      url = build_url(data)
      Thread.new {open(url)}
    end

    def build_url(data)
      [BASE_URI, @srv_id, "&", ArgParser.parse(data).to_params].join
    end
  end
end

