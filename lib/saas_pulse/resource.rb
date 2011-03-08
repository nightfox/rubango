module Totango
  class NoAdapterError < StandardError; end

  module Resource
    @sp_defaults = {
      :organization => "Default Org",
      :user => "Default User",
      :activity => "Default Activity",
      :module => "Default Module"
    }

    module ClassMethods
      def sp_default(key, val)
        raise ArgumentError, "Key #{key.inspect} is not a valid option" unless @sp_defaults.keys.member?(key)

        sp_defaults[key] = val
      end

      # action<Symbol>:: Action to track
      # opts<Hash>:: Override defaults and set conditional tracking
      def track(action, *opts)
        tracker = Totango::Tracker.new(action, *opts)
        sp_trackers << tracker unless sp_trackers.find {|t| t.action.to_s == action.to_s}
      end

      def sp_trackers
        @__sp_trackers__ ||= []
      end

      private

      def inherited(klass)
        super(klass)
        klass.instance_variable_set :@sp_defaults, @sp_defaults.dup
      end
    end

    def self.included(base)
      base.extend ClassMethods
      class << base; attr_reader :sp_defaults end
      base.instance_variable_set :@sp_defaults, @sp_defaults.dup
      base.send(Totango.adapter.hook, :sp_run)
    end

    private

    def sp_run
      raise NoAdapterError, "No adapter has been set" unless Totango.adapter

      tracker = self.class.sp_trackers.find do |t|
        t.action.to_s == send(Totango.adapter.action_finder).to_s
      end

      return unless tracker

      if condition = tracker.opts[:if]
        return unless instance_eval(&condition)
      end

      Totango.track({
        :o => sp_opt(tracker, :organization),
        :a => sp_opt(tracker, :activity),
        :m => sp_opt(tracker, :module),
        :u => sp_opt(tracker, :user)
      })
    end

    def sp_opt(tracker, param)
      value = tracker.opts[param] || sp_defaults[param]

      return instance_eval(&value) if Proc === value
      value
    end

    def sp_defaults
      self.class.sp_defaults
    end
  end
end

