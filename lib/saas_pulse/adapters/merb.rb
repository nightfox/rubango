require 'saas_pulse/adapters/base'

module SaasPulse
  module Adapters
    module Merb
      extend SaasPulse::Adapters::Base

      register_adapter :merb
      hook_method :before
      action_finder :action_name

      sp_defaults :activity, proc { action_name }
      sp_defaults :module,   proc { controller_name }
    end
  end
end

