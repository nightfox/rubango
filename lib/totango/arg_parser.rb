module Totango
  class InvalidParamError < StandardError; end

  class ArgParser
    class << self
      attr_reader :named_args

      def parse(args)
        new.tap do |parser|
          args.each do |arg, val|
            param = registered_args[arg]
            param = custom_param_name(arg) unless param

            parser[param] = val
          end
        end
      end

      private

      def parses_arg(name, *aliases)
        register_named_arg! name
        attr_reader name

        aliases.unshift(name).each do |argname|
          registered_args[argname] = name
        end
      end

      def registered_args
        @__registered_args__ ||= {}
      end

      def custom_param_name(arg)
        return "sdr_u.name" if arg == :user_name
        return "sdr_u.ofid" if arg == :user_ofid

        ["sdr_o", arg].join(".").to_sym
      end

      def register_named_arg!(name)
        @named_args ||= []
        @named_args << name
      end
    end

    parses_arg :sdr_a,          :activity
    parses_arg :sdr_o,          :account_id
    parses_arg :sdr_odn,        :account_name
    parses_arg :sdr_m,          :module
    parses_arg :sdr_u,          :user_id
    parses_arg :sdr_ofid,       :organization_foreign_id

    def values_hash
      @__values_hash__ ||= {}
    end

    def to_params
      args = (ArgParser.named_args + values_hash.keys).uniq

      args.map do |arg|
        [arg, CGI.escape(self[arg].to_s)].join("=") if arg && self[arg]
      end.compact.join("&")
    end

    def [](arg)
      values_hash[arg]
    end

    def []=(arg, val)
      values_hash[arg] = val
    end
  end
end

