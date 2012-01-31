module Totango
  class Config
    class <<self
      def defaults
        @defaults ||= {
          :on => false,
          :suppress_output => false,
          :synchronous => false
        }
      end

      def [](setting)
        defaults[setting]
      end

      def []=(setting, value)
        defaults[setting] = value
      end

      def use
        yield defaults
      end
    end
  end
end

