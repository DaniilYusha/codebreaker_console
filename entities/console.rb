# frozen_string_literal: true

class Console
  include Questioner
  attr_reader :output, :registrator, :decorator, :statistics, :game

  FILE_PATH = './db/statistics.yml'

  def initialize
    @output = OutputService.new
    @registrator = RegistratorService.new
    @decorator = Decorator.new
    @statistics = Codebreaker::StatisticsService.new FILE_PATH
    @error_exist = false
    @output.introduction
  end

  def choose_option
    ask_choose_game_option
    choose_option
  end

  def start
    system 'clear'
    @game = @registrator.game_registration
    start_game_process
  end

  def stats
    system 'clear'
    return @output.no_stats unless File.exist? FILE_PATH

    @output.show_stats
    decorated_stats = @decorator.stats_beautify @statistics.sort_statistics
    decorated_stats.each_with_index do |user, index|
      puts @output.rating + index.next.to_s
      user.each { |key, value| puts "#{key} #{value}" }
      puts '=' * 25
    end
  end

  def rules
    system 'clear'
    @output.show_rules
  end

  def hint
    game.no_hints? ? @output.no_hints : puts(@output.show_hint + @game.take_hint.to_s)
  end

  def leave
    @output.bye
    exit true
  end

  def start_game_process
    system 'clear'
    until game.lose?
      show_current_state
      ask_choose_command_in_game_process
    end
    lost
  end

  private

  def show_current_state
    puts @output.show_difficulty + @game.difficulty.kind.to_s
    puts @output.show_attempts + @game.difficulty.current_attempts.to_s
    puts @output.show_hints + @game.difficulty.current_hints.to_s
  end

  def check_guess(guess)
    won if game.win? guess
    error_message guess
    @decorator.result_beautify game.check_attempt guess unless @error_exist
  end

  def lost
    puts @output.lose + @game.secret_code.join
    ask_about_new_game
  end

  def won
    puts @output.win + @game.secret_code.join
    ask_about_save_results
    ask_about_new_game
  end

  def start_new_game
    system 'clear'
    @game.new_game
    start_game_process
  end

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
