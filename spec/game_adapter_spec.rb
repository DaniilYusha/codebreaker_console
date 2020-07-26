# frozen_string_literal: true

RSpec.describe GameAdapter do
  let(:console) { Console.new }
  let(:game_adapter) { described_class.new(console) }
  let(:user) { Codebreaker::User.new('Daniil') }
  let(:difficulty) { Codebreaker::Difficulty.new('hell') }
  let(:game) { Codebreaker::Game.new(user, difficulty) }

  describe '.initialize' do
    it 'has field-instance of Console class' do
      expect(game_adapter.instance_variable_get(:@console).class).to eq Console
    end
  end

  describe '#hint' do
    context 'when hints left' do
      it 'puts no hints message' do
        console.instance_variable_set(:@game, game)
        console.game.difficulty.instance_variable_set(:@current_hints, 0)
        expect { game_adapter.hint(game) }.to output(console.output.no_hints).to_stdout
      end
    end

    it 'puts hint with message' do
      console.instance_variable_set(:@game, game)
      console.game.difficulty.instance_variable_set(:@current_hints, 1)
      expect(game_adapter.hint(game).class).to eq NilClass
    end
  end

  describe '#check_guess' do
    context 'when guess equals to secret code' do
      it 'calls won method' do
        expect(game_adapter).to receive(:won).with(game)
        game_adapter.check_guess(game, game.secret_code.join)
      end
    end

    context 'when incorrect guess passed' do
      it 'puts error message' do
        expect(game_adapter).to receive(:error_message).with('YUSHA')
        game_adapter.check_guess(game, 'YUSHA')
      end
    end
  end

  describe '#lost' do
    it 'puts lose message' do
      game.difficulty.instance_variable_set(:@current_attempts, 0)
      allow(console).to receive(:ask_about_new_game)
      expect { game_adapter.lost(game) }.to output(I18n.t(:lose) + game.secret_code.join + "\n").to_stdout
    end
  end

  describe '#won' do
    it 'puts win message' do
      allow(console).to receive(:ask_about_save_results)
      allow(console).to receive(:ask_about_new_game)
      expect { game_adapter.won(game) }.to output(I18n.t(:win) + game.secret_code.join + "\n").to_stdout
    end
  end
end
