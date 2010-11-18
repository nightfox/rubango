module SaasPulse
  class InvalidParamError < StandardError; end

  class ArgParser
    class <<self
      attr_reader :named_args

      def parse(args)
        new.tap do |parser|
          args.each do |arg, val|
            meth = registered_args[arg]
            raise InvalidParamError, "'#{arg}' does not map to a valid param" unless meth

            parser.send(:"#{meth}=", val)
          end
        end
      end

      private

      def parses_arg(name, *aliases)
        register_named_arg! name
        attr_accessor name

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

    def to_params
      ArgParser.named_args.map do |arg|
        [arg, CGI.escape(send(arg).to_s)].join("=")
      end.join("&")
    end
  end
end

