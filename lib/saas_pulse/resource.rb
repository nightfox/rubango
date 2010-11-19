module SaasPulse
  class NoAdapterError < StandardError; end

  module Resource
    @__sp_defaults__ = {
      :organization => "Default Org",
      :user => "Default User",
      :activity => "Default Activity",
      :module => "Default Module"
    }

    module ClassMethods
      def sp_defaults(key, val)
        raise ArgumentError, "Key #{key.inspect} is not a valid option" unless @__sp_defaults__.keys.member?(key)

        @__sp_defaults__[key] = val
      end

      # action<Symbol>:: Action to track
      # opts<Hash>:: Override defaults and set conditional tracking
      def track(action, opts={})
        sp_trackers << SaasPulse::Tracker.new(action, opts)
      end

      def sp_trackers
        @__sp_trackers__ ||= []
      end

      private

      def inherited(klass)
        super(klass)
        klass.instance_variable_set :@__sp_defaults__, @__sp_defaults__.dup
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.instance_variable_set :@__sp_defaults__, @__sp_defaults__.dup
      base.send(SaasPulse.adapter.hook, :sp_run)
    end

    private

    def sp_run
      adapter = SaasPulse.adapter
      raise NoAdapterError, "No adapter has been set" unless adapter

      tracker = self.class.sp_trackers.find do |t|
        t.action == send(adapter.action_finder)
      end

      return unless tracker

      SaasPulse.track({
        :o => sp_opt(tracker, :organization),
        :a => sp_opt(tracker, :activity),
        :m => sp_opt(tracker, :module),
        :u => sp_opt(tracker, :user)
      })
    end

    def sp_opt(param, tracker)
      value = tracker[param] || sp_defaults[param]

      return instance_eval(&value) if Proc === value
      value
    end

    def sp_defaults
      self.class.instance_variable_get :@__sp_defaults__
    end
  end
end

