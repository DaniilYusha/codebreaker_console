# frozen_string_literal: true

RSpec.describe RegistratorService do
  let(:registrator) { described_class.new }

  before { allow($stdout).to receive(:write) }

  describe '#game_registration' do
    it 'returns an instance of Game class' do
      allow(registrator).to receive(:gets).and_return('Daniil', 'easy')
      expect(registrator.game_registration.class).to eq Codebreaker::Game
    end

    context 'when name is incorrect' do
      it 'puts incorrect name passed message' do
        allow(registrator).to receive(:gets).and_return('Po', 'Pop')
        allow(registrator).to receive(:create_difficulty)
        expect { registrator.game_registration }.to output(
          "#{I18n.t :enter_name}\n" \
          "#{I18n.t :short_name}\n" \
          "#{I18n.t :enter_name}\n"
        ).to_stdout
      end
    end

    context 'when difficulty is an incorrect' do
      it 'puts incorrect difficulty passed message' do
        allow(registrator).to receive(:gets).and_return('hel', 'hell')
        allow(registrator).to receive(:create_user)
        expect { registrator.game_registration }.to output(
          "#{I18n.t :enter_difficulty}\n" \
          "#{I18n.t :no_difficulty}\n" \
          "#{I18n.t :enter_difficulty}\n"
        ).to_stdout
      end
    end
  end
end
