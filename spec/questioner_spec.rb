# frozen_string_literal: true

RSpec.describe Console do
  let(:console) { described_class.new }

  before { allow($stdout).to receive(:write) }

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

  describe '#ask_choose_command_in_game_process' do
    it 'exit from game when passed exit command' do
      allow(console).to receive(:gets).and_return(Questioner::EXIT_COMMAND)
      expect { console.ask_choose_command_in_game_process }.to raise_error(SystemExit)
    end

    it 'calls hint method when passed hint command' do
      allow(console).to receive(:gets).and_return(Questioner::HINT_COMMAND)
      expect(console).to receive(:hint)
      console.ask_choose_command_in_game_process
    end
  end
end
