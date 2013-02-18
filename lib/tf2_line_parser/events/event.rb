module TF2LineParser

  module Events

    class Event

      def self.time_format
        @time_format ||= '%m/%d/%Y - %T'
      end

      def self.regex_time
        @regex_time ||= 'L (?\'time\'.*):'
      end

      def self.regex_player
        @regex_player ||= '"(?\'player_nick\'.+)<(?\'player_uid\'\d+)><(?\'player_steamid\'STEAM_\S+)><(?\'player_team\'Red|Blue)>"'
      end

      def self.regex_target
        @regex_target ||= '"(?\'target_nick\'.+)<(?\'target_uid\'\d+)><(?\'target_steamid\'STEAM_\S+)><(?\'target_team\'Red|Blue)>"'
      end

      def self.regex_console
        @regex_console ||= '"Console<0><Console><Console>"'
      end

      def self.regex_message
        @regex_message ||= '"(?\'message\'.*)"'
      end

      def self.types
        #ordered by how common the messages are
        @types ||= [Damage, Heal, PickupItem, Assist, Kill, PointCapture, ChargeDeployed, Say, TeamSay, RoundWin, CurrentScore, RoundStart, Domination, Revenge, ConsoleSay, MatchEnd, FinalScore, RoundStalemate, Unknown]
      end

      def self.regex_results(matched_line)
        attributes.collect do |attribute|
          matched_line[attribute]
        end
      end

      def parse_time(time_string)
        Time.strptime(time_string, Event.time_format)
      end

    end

  end
end
