require 'spec_helper'


module TF2LineParser

  describe Parser do

    let(:log_file)   { File.expand_path('../../../fixtures/logs/broder_vs_epsilon.log',  __FILE__) }
    let(:log)        { File.read(log_file) }
    let(:log_lines)  { log.lines.map(&:to_s) }

    describe '#new' do

      it 'takes the log line and gets the date from it' do
        Parser.new(log_lines.first).parse.time.should eql Time.local(2013, 2, 7, 21, 21, 8)
      end

    end

    describe '#parse' do

      def parse(line)
        Parser.new(line).parse
      end

      it 'recognizes damage' do
        line = log_lines[1001]
        player_name = "Epsilon numlocked"
        player_steam_id = "STEAM_0:1:16347045"
        player_team = 'Red'
        value = '69'
        Events::Damage.should_receive(:new).with(anything, player_name, player_steam_id, player_team, value)
        parse(line)
      end

      it 'recognizes a round start' do
        line = log_lines[1245]
        Events::RoundStart.should_receive(:new)
        parse(line)
      end

      it 'recognizes a point capture' do
        line = log_lines[1360]
        team = 'Blue'
        cap_number = '2'
        cap_name = '#Badlands_cap_cp3'
        Events::PointCapture.should_receive(:new).with(anything, team, cap_number, cap_name)
        parse(line)
      end

      it 'recognizes a round win' do
        line = log_lines[1439]
        winner = "Blue"
        Events::RoundWin.should_receive(:new).with(anything, winner)
        parse(line)
      end

      it 'recognizes a stalemate round' do
        line = 'L 02/07/2013 - 21:34:05: World triggered "Round_Stalemate"'
        Events::RoundStalemate.should_receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes a match end' do
        line = log_lines[4169]
        reason = "Reached Win Difference Limit"
        Events::MatchEnd.should_receive(:new).with(anything, reason)
        parse(line)
      end

      it 'recognizes a heal' do
        line = log_lines[1433]
        player_name = "Epsilon KnOxXx"
        player_steam_id = "STEAM_0:1:12124893"
        player_team = "Red"
        target_name = "Epsilon numlocked"
        target_steam_id = "STEAM_0:1:16347045"
        target_team = "Red"
        value = '1'
        Events::Heal.should_receive(:new).with(anything, player_name, player_steam_id, player_team, target_name, target_steam_id, target_team, value)
        parse(line)
      end

      it 'recognizes a kill' do
        line = log_lines[1761]
        player_name = "Epsilon basH."
        player_steam_id = "STEAM_0:1:15829615"
        player_team = "Red"
        target_name = "broder jukebox"
        target_steam_id = "STEAM_0:1:13978585"
        target_team = "Blue"
        Events::Kill.should_receive(:new).with(anything, player_name, player_steam_id, player_team, target_name, target_steam_id, target_team)
        parse(line)
      end

      it 'recognizes an assist' do
        line = log_lines[1451]
        player_name =  "broder jukebox"
        player_steam_id = "STEAM_0:1:13978585"
        player_team = "Blue"
        target_name = "Epsilon Mitsy"
        target_steam_id = "STEAM_0:0:16858056"
        target_team = "Red"
        Events::Assist.should_receive(:new).with(anything, player_name, player_steam_id, player_team, target_name, target_steam_id, target_team)
        parse(line)
      end


      it 'recognizes chat' do
        line = log_lines[89]
        name = "Epsilon KnOxXx"
        steam_id =  "STEAM_0:1:12124893"
        team = 'Red'
        message = "it's right for the ping"
        Events::Say.should_receive(:new).with(anything, name, steam_id, team, message)
        parse(line)
      end

      it 'recognizes team chat' do
        line = log_lines[303]
        name = "broder mirelin"
        steam_id = "STEAM_0:1:18504112"
        team = 'Blue'
        message = ">>> USING UBER <<<[info] "
        Events::TeamSay.should_receive(:new).with(anything, name, steam_id, team, message)
        parse(line)
      end

      it 'recognizes dominations' do
        line = log_lines[1948]
        name = "Epsilon basH."
        steam_id = "STEAM_0:1:15829615"
        team = "Red"
        target_name = "broder jukebox"
        target_steam_id = "STEAM_0:1:13978585"
        target_team =  "Blue"
        Events::Domination.should_receive(:new).with(anything, name, steam_id, team, target_name, target_steam_id, target_team)
        parse(line)
      end

      it 'recognizes revenges' do
        line = log_lines[2354]
        name = "broder jukebox"
        steam_id = "STEAM_0:1:13978585"
        team = "Blue"
        target_name = "Epsilon basH."
        target_steam_id = "STEAM_0:1:15829615"
        target_team =  "Red"
        Events::Revenge.should_receive(:new).with(anything, name, steam_id, team, target_name, target_steam_id, target_team)
        parse(line)
      end

      it 'recognizes current score' do
        line = log_lines[1442]
        team = "Blue"
        score = "1"
        Events::CurrentScore.should_receive(:new).with(anything, team, score)
        parse(line)
      end

      it 'recognizes final score' do
        line = log_lines[4170]
        team = "Red"
        score = "6"
        Events::FinalScore.should_receive(:new).with(anything, team, score)
        parse(line)
      end

      it 'recognizes item pickup' do
        line = log_lines[51]
        name = 'Epsilon Mike'
        steam_id = "STEAM_0:1:1895232"
        team = "Blue"
        item = 'medkit_medium'
        Events::PickupItem.should_receive(:new).with(anything, name, steam_id, team, item)
        parse(line)
      end

      it 'recognizes stalemate round' do
        line = 'L 02/07/2013 - 21:21:08: World triggered "Round_Stalemate"'
        Events::RoundStalemate.should_receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes ubercharges' do
        line = log_lines[1416]
        name = "broder mirelin"
        steam_id = "STEAM_0:1:18504112"
        team = "Blue"
        Events::ChargeDeployed.should_receive(:new).with(anything, name, steam_id, team)
        parse(line)
      end

      it 'recognizes medic deaths' do
        line = log_lines[1700]
        medic_name = "broder mirelin"
        medic_steam_id = "STEAM_0:1:18504112"
        medic_team = "Blue"
        killer_name = "Epsilon numlocked"
        killer_steam_id = "STEAM_0:1:16347045"
        killer_team = "Red"
        Events::MedicDeath.should_receive(:new).with(anything, killer_name, killer_steam_id, killer_team, medic_name, medic_steam_id, medic_team)
        parse(line)
      end

      it 'recognizes role changes' do
        line = log_lines[1712]
        player_name = "broder bybben"
        player_steam_id = "STEAM_0:1:159631"
        player_team = "Blue"
        role = 'scout'
        Events::RoleChange.should_receive(:new).with(anything, player_name, player_steam_id, player_team, role)
        parse(line)
      end

      it 'recognizes round length' do
        line = log_lines[2275]
        length = "237.35"
        Events::RoundLength.should_receive(:new).with(anything, length)
        parse(line)
      end

      it 'recognizes capture block' do
        line = log_lines[3070]
        name = "Epsilon basH."
        steam_id = "STEAM_0:1:15829615"
        team = "Red"
        cap_number = "2"
        cap_name = "#Badlands_cap_cp3"
        Events::CaptureBlock.should_receive(:new).with(anything, name, steam_id, team, cap_number, cap_name)
        parse(line)
      end

      it 'recognizes suicides' do
        line = log_lines[76]
        name = ".schocky"
        steam_id = "STEAM_0:0:2829363"
        team = "Red"
        suicide_method = "world"
        Events::Suicide.should_receive(:new).with(anything, name, steam_id, team, suicide_method)
        parse(line)
      end

      it 'deals with unknown lines' do
        line = log_lines[0]
        time = "02/07/2013 - 21:21:08"
        unknown = 'Log file started (file "logs/L0207006.log") (game "/home/hz00112/tf2/orangebox/tf") (version "5198")'
        Events::Unknown.should_receive(:new).with(time, unknown)
        parse(line)
      end


      it 'can parse all lines in the example log files without exploding' do
        broder_vs_epsilon   = File.expand_path('../../../fixtures/logs/broder_vs_epsilon.log',  __FILE__)
        special_characters  = File.expand_path('../../../fixtures/logs/special_characters.log',  __FILE__)
        ntraum_example      = File.expand_path('../../../fixtures/logs/example.log',  __FILE__)
        log_files = [broder_vs_epsilon, special_characters, ntraum_example]

        log_files.each do |log_file|
          log = File.read(log_file)
          expect {
            log.lines.map(&:to_s).each do |line|
              parse(line)
            end
          }.to_not raise_error
        end
      end


    end

  end
end
