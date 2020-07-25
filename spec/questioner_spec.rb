# frozen_string_literal: true

RSpec.describe Console do
  let(:stats_path) { './db/test.yml' }
  let(:user) { Codebreaker::User.new('Daniil') }
  let(:difficulty) { Codebreaker::Difficulty.new('hell') }
  let(:game) { Codebreaker::Game.new(user, difficulty) }
  let(:console) { described_class.new }

  before do
    console.instance_variable_set(:@game, game)
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
      allow(console).to receive(:start_game_process)
      expect(console).to receive(:start)
      console.ask_choose_game_option
    end
  end

  describe '#ask_about_save_results' do
    context "when answer is #{Questioner::NO}" do
      it 'move to next step' do
        allow(console).to receive(:gets).and_return(Questioner::NO)
        expect(console.ask_about_save_results.class).to eq NilClass
      end
    end

    context "when answer is #{Questioner::YES}" do
      it 'saves result to file' do
        allow(console).to receive(:gets).and_return(Questioner::YES)
        expect(console.ask_about_save_results.class).to eq NilClass
      end
    end

    context 'when passed unexpected command' do
      it 'puts unexpected command message' do
        allow(console).to receive(:gets).and_return('YUSHA', 'n')
        expect { console.ask_about_save_results }.to output(console.output.commands_description).to_stdout
      end
    end
  end

  describe '#ask_about_new_game' do
    context "when answer is #{Questioner::NO}" do
      it 'exit from game' do
        allow(console).to receive(:gets).and_return(Questioner::NO)
        expect { console.ask_about_new_game }.to raise_error(SystemExit)
      end
    end

    context "when answer is #{Questioner::YES}" do
      it 'starts a new game and leave it' do
        allow(console).to receive(:gets).and_return(Questioner::YES, 'exit')
        expect { console.ask_about_new_game }.to raise_error(SystemExit)
      end
    end
  end

  describe '#ask_choose_command_in_game_process' do
    context "when passed #{Questioner::EXIT_COMMAND} command" do
      it 'leave the game' do
        allow(console).to receive(:gets).and_return(Questioner::EXIT_COMMAND)
        expect { console.ask_choose_command_in_game_process }.to raise_error(SystemExit)
      end
    end

    context "when passed #{Questioner::HINT_COMMAND} command" do
      it 'calls hint method' do
        allow(console).to receive(:gets).and_return(Questioner::HINT_COMMAND)
        expect(console).to receive(:hint)
        console.ask_choose_command_in_game_process
      end
    end
  end
end
