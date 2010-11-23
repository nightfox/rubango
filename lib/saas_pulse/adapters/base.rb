module SaasPulse
  module Adapters
    module Base
      def self.extended(base)
        SaasPulse.adapter = SaasPulse::Adapter.new
      end

      private

      def included(klass)
        klass.send(:include, SaasPulse::Resource) unless klass.include?(SaasPulse::Resource)
        (@defaults || []).each do |e|
          klass.sp_default *e
        end
      end

      def sp_default(k, v)
        @defaults ||= []
        @defaults << [k,v]
      end

      def register_adapter(name)
        SaasPulse.adapter.name = name
      end

      def hook_method(name)
        SaasPulse.adapter.hook = name
      end

      def action_finder(name)
        SaasPulse.adapter.action_finder = name
      end
    end
  end
end

