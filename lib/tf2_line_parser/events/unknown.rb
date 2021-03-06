module TF2LineParser
  module Events

    class Unknown < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_unknown}/
      end

      def self.regex_unknown
        "(?'unknown'.*)"
      end

      def self.attributes
        @attributes ||= [:time, :unknown]
      end

      attr_accessor :time, :unknown

      def initialize(time, unknown)
        @time = parse_time(time)
        @unknown = unknown
      end

    end

  end
end
