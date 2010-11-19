module SaasPulse
  module Resource
    SP_DEFAULTS = {
      :organization => "Default Org",
      :user => "Default User",
      :activity => "Default Activity",
      :module => "Default Module"
    }

    module ClassMethods
      def sp_defaults(key, val)
        raise ArgumentError, "Key #{key.inspect} is not a valid option" unless @defaults.keys.member?(key)

        @defaults[key] = val
      end

      # action<Symbol>:: Action to track
      # opts<Hash>:: Override defaults and set conditional tracking
      def track(action, opts={})
        @trackers << SaasPulse::Tracker.new(action, opts)
      end

      private

      def inherited(klass)
        super(klass)
        klass.instance_variable_set :@defaults, @defaults
        klass.instance_variable_set :@trackers, []
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.instance_variable_set :@defaults, @defaults
      base.instance_variable_set :@trackers, []
    end
  end
end

