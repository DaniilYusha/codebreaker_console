# frozen_string_literal: true

RSpec.describe Console do
  let(:stats_path) { './db/test.yml' }
  let(:user) { Codebreaker::User.new('Daniil') }
  let(:difficulty) { Codebreaker::Difficulty.new('hell') }
  let(:game) { Codebreaker::Game.new(user, difficulty) }
  let(:console) { described_class.new }

  before { allow($stdout).to receive(:write) }

  describe '#hint' do
    context 'when hints left' do
      it 'puts no hints message' do
        console.instance_variable_set(:@game, game)
        console.game.difficulty.instance_variable_set(:@current_hints, 0)
        expect { console.hint }.to output(console.output.no_hints).to_stdout
      end
    end

    it 'puts hint with message' do
      console.instance_variable_set(:@game, game)
      console.game.difficulty.instance_variable_set(:@current_hints, 1)
      expect(console.hint.class).to eq NilClass
    end
  end

  describe '#rules' do
    it 'puts rules' do
      expect { console.rules }.to output(console.output.show_rules).to_stdout
    end
  end

  describe '#stats' do
    before do
      console.instance_variable_set(:@statistics, Codebreaker::StatisticsService.new(stats_path))
      file = File.open(stats_path, 'w')
      data = [{ player: 'Daniil', difficulty: 'hell', attempts_total: 5,
                attempts_used: 1, hints_total: 1, hints_used: 0 }]
      file.write(data.to_yaml)
      file.close
    end

    after { File.delete(stats_path) }

    context 'when file is not exists or empty' do
      it 'puts no statistics message' do
        expect { console.stats }.to output(console.output.no_stats).to_stdout
      end
    end

    it 'puts statistics header' do
      expect { console.stats }.to output(console.output.show_stats).to_stdout
    end

    it "puts user's statistics" do
      expect(console.stats.class).to eq Array
    end
  end

  describe '#start' do
    it 'sets game instance variable' do
      allow(console).to receive(:start_game_process)
      expect(console.registrator).to receive(:game_registration)
      console.start
    end
  end

  describe '#start_game_process' do
    before { console.instance_variable_set(:@game, game) }

    context 'when incorrect guess passed' do
      it 'puts error' do
        allow(console).to receive(:gets).and_return('ssda')
        allow(console).to receive(:ask_about_new_game)
        expect(console).to receive(:error_message).with('ssda').at_least(:once)
        console.start_game_process
      end
    end

    context 'when wins the game' do
      before(:each) { console.game.difficulty.instance_variable_set(:@current_attempts, 1) }

      it 'receive won method' do
        allow(console).to receive(:ask_about_new_game)
        allow(console).to receive(:gets).and_return(console.game.secret_code.join)
        expect(console).to receive(:won)
        console.start_game_process
      end

      it 'ask to save results' do
        allow(console).to receive(:ask_about_new_game)
        allow(console).to receive(:gets).and_return(console.game.secret_code.join)
        expect(console).to receive(:ask_about_save_results)
        console.start_game_process
      end
    end

    context 'when loses the game' do
      it 'receive lost method' do
        console.game.difficulty.instance_variable_set(:@current_attempts, 1)
        allow(console).to receive(:gets).and_return('1234')
        expect(console).to receive(:lost)
        console.start_game_process
      end
    end
  end

  describe '#leave' do
    it 'puts bye message and exit' do
      expect { console.leave }.to raise_error(SystemExit)
    end
  end
end
