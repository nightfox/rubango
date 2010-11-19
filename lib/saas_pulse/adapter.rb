module SaasPulse
  class << self; attr_accessor :adapter end

  class Adapter
    attr_accessor :name, :hook, :action_finder

    def run

      return unless tracker

      if conditional = tracker.opts[:if]
        return unless instance_eval(&conditional)
      end

    end
  end
end


