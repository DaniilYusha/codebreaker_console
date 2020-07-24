# frozen_string_literal: true

RSpec.describe Console do
  let(:stats_path) { './db/test.yml' }
  let(:user) { Codebreaker::User.new('Daniil') }
  let(:difficulty) { Codebreaker::Difficulty.new('hell') }
  let(:game) { Codebreaker::Game.new(user, difficulty) }
  let(:console) { described_class.new }

  before do
    allow($stdout).to receive(:write)
  end

  describe '#hint' do
    it 'puts error when hints left' do
      console.instance_variable_set(:@game, game)
      console.game.difficulty.instance_variable_set(:@current_hints, 0)
      expect { console.hint }.to output(console.output.no_hints).to_stdout
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

    it 'puts message when file is not exists or empty' do
      expect { console.stats }.to output(console.output.no_stats).to_stdout
    end

    it 'puts statistics header' do
      expect { console.stats }.to output(console.output.show_stats).to_stdout
    end
  end

  describe '#start' do
    it 'sets game instance variable' do
      allow(console).to receive(:game_process)
      expect(console.registrator).to receive(:game_registration)
      console.start
    end
  end

  describe '#game_process' do
    before { console.instance_variable_set(:@game, game) }

    context 'when incorrect guess passed' do
      it 'puts error' do
        allow(console).to receive(:gets).and_return('ssda')
        allow(console).to receive(:ask_about_new_game)
        expect(console).to receive(:error_message).with('ssda').at_least(:once)
        console.game_process
      end
    end

    context 'when wins the game' do
      before(:each) { console.game.difficulty.instance_variable_set(:@current_attempts, 1) }
      # after(:all) { File.delete(stats_path) }

      it 'receive won method' do
        allow(console).to receive(:ask_about_new_game)
        allow(console).to receive(:gets).and_return(console.game.secret_code.join)
        expect(console).to receive(:won)
        console.game_process
      end

      it 'ask to save results' do
        allow(console).to receive(:ask_about_new_game)
        allow(console).to receive(:gets).and_return(console.game.secret_code.join)
        expect(console).to receive(:ask_about_save_results)
        console.game_process
      end
    end

    context 'when loses the game' do
      it 'receive lost method' do
        console.game.difficulty.instance_variable_set(:@current_attempts, 1)
        allow(console).to receive(:gets).and_return('1234')
        expect(console).to receive(:lost)
        console.game_process
      end
    end
  end

  describe '#ask_choose_game_option' do
    it 'puts commands description message' do
      allow(console).to receive(:gets).and_return('exit')
      allow(console).to receive(:leave)
      expect { console.ask_choose_game_option }.to output(console.output.commands_description).to_stdout
    end

    it 'puts unexpected command message' do
      allow(console).to receive(:gets).and_return('YUSHA')
      expect { console.ask_choose_game_option }.to output(console.output.unexpected_command).to_stdout
    end

    it 'calls stats command' do
      allow(console).to receive(:gets).and_return('stats')
      expect(console).to receive(:stats)
      console.ask_choose_game_option
    end

    it 'calls rules command' do
      allow(console).to receive(:gets).and_return('rules')
      expect(console).to receive(:rules)
      console.ask_choose_game_option
    end

    it 'calls start command' do
      allow(console).to receive(:gets).and_return('start')
      allow(console).to receive(:game_process)
      expect(console).to receive(:start)
      console.ask_choose_game_option
    end
  end

  describe '#ask_about_save_results' do
    it 'returns when answer is NO' do
      allow(console).to receive(:gets).and_return(Questioner::NO)
      expect(console.ask_about_save_results.class).to eq NilClass
    end
  end

  describe '#ask_about_new_game' do
    it 'exit from game when answer is NO' do
      allow(console).to receive(:gets).and_return(Questioner::NO)
      expect { console.ask_about_new_game }.to raise_error(SystemExit)
    end
  end

  describe '#leave' do
    it 'puts bye message and exit' do
      expect { console.leave }.to raise_error(SystemExit)
    end
  end
end
