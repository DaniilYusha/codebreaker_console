# frozen_string_literal: true

class GameAdapter

  def initialize(console)
    @console = console
    @error_exist = false
  end

  def hint(game)
    game.no_hints? ? @console.output.no_hints : puts(@console.output.show_hint + game.take_hint.to_s)
  end

  def check_guess(game, guess)
    won game if game.win? guess
    error_message guess
    @console.decorator.result_beautify game.check_attempt guess unless @error_exist
  end

  def start_new_game(game)
    system 'clear'
    game.new_game
    @console.start_game_process
  end

  def lost(game)
    puts @console.output.lose + game.secret_code.join
    @console.ask_about_new_game
  end

  def won(game)
    puts @console.output.win + game.secret_code.join
    @console.ask_about_save_results
    @console.ask_about_new_game
  end

  private

  def error_message(obj)
    begin
      Codebreaker::GuessChecker.validate obj
    rescue Codebreaker::DigitsCountError, Codebreaker::DigitRangeError => e
      @error_exist = true
      return puts e.message
    end
    @error_exist = false
  end
end
