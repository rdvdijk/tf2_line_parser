module TF2LineParser
  module Events

    class ChargeDeployed < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "chargedeployed"/
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team]
      end

      attr_accessor :time, :player

      def initialize(time, name, steam_id, team)
        @time = parse_time(time)
        @player = Player.new(name, steam_id, team)
      end

    end
  end
end
