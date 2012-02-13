module Totango
  class InvalidParamError < StandardError; end

  class ArgParser
    class <<self
      attr_reader :named_args

      def parse(args)
        new.tap do |parser|
          args.each do |arg, val|
            param = registered_args[arg]
            raise InvalidParamError, "'#{arg}' does not map to a valid param" unless param

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

      def register_named_arg!(name)
        @named_args ||= []
        @named_args << name
      end
    end

    parses_arg :sdr_a, :a, :act, :activity
    parses_arg :sdr_o, :o, :org, :organization
    parses_arg :sdr_m, :m, :mod, :module
    parses_arg :sdr_u, :u, :user
    parses_arg :sdr_ofid, :ofid, :organization_foreign_id

    def to_params
      ArgParser.named_args.map do |arg|
        [arg, CGI.escape(self[arg].to_s)].join("=")
      end.join("&")
    end

    def [](arg)
      instance_variable_get :"@#{arg}"
    end

    def []=(arg, val)
      instance_variable_set :"@#{arg}", val
    end
  end
end

