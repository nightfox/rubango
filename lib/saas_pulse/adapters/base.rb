require 'saas_pulse/adapter'

module SaasPulse
  module Adapters
    module Base
      def self.extended(base)
        SaasPulse.adapter = SaasPulse::Adapter.new
      end

      def included(klass)
        klass.send(:include, SaasPulse::Resource) unless include?(SaasPulse::Resource)
        (@defaults || []).each do |e|
          klass.sp_defaults *e
        end
      end

      private

      def sp_defaults(k, v)
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

