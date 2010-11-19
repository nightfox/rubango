module SaasPulse
  class Tracker
    def initialize(action, activity=nil, opts={})
      @action = action
      @opts = opts

      case activity
      when String
        opts[:activity] = activity
      when Hash
        @opts = activity
      else
        raise ArgumentError, "activity must be a String or Hash"
      end
    end

    attr_reader :action, :opts
  end
end

