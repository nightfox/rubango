module SaasPulse
  class Tracker
    def initialize(action, *opts)
      @action = action
      activity = opts.shift
      @opts = opts.empty? ? {} : opts.shift

      return unless activity

      case activity
      when String
        @opts[:activity] = activity
      when Hash
        @opts = activity
      else
        raise ArgumentError, "activity must be a String or Hash"
      end
    end

    attr_reader :action, :opts
  end
end

