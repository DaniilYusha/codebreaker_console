# frozen_string_literal: true

RSpec.describe RegistratorService do
  let(:registrator) { described_class.new }
  
  before { allow($stdout).to receive(:write) }

  describe '#game_registration' do
    it 'returns an instance of Game class' do
      allow(registrator).to receive(:gets).and_return('Daniil', 'easy')
      expect(registrator.game_registration.class).to eq Codebreaker::Game
    end

    it 'puts error when name is an incorrect' do
      allow(registrator).to receive(:gets).and_return('Po', 'Pop', 'hell')
      expect { registrator.game_registration }.to output(
        "Please, enter your name(3-20 symbols):\n" \
        "Name is too short\n\n" \
        "Please, enter your name(3-20 symbols):\n" \
        "Choose difficulty: easy, medium, hell:\n"
      ).to_stdout
    end

    it 'puts error when difficulty is an incorrect' do
      allow(registrator).to receive(:gets).and_return('Pop', 'hel', 'hell')
      expect { registrator.game_registration }.to output(
        "Please, enter your name(3-20 symbols):\n" \
        "Choose difficulty: easy, medium, hell:\n" \
        "No such difficulty\n\n" \
        "Choose difficulty: easy, medium, hell:\n"
      ).to_stdout
    end
  end
end
