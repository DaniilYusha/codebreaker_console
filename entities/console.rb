# frozen_string_literal: true

class Console
  include Questioner
  attr_reader :output, :registrator, :decorator, :statistics, :game_adapter, :game

  FILE_PATH = './db/statistics.yml'

  def initialize
    @output = OutputService.new
    @registrator = RegistratorService.new
    @decorator = Decorator.new
    @statistics = Codebreaker::StatisticsService.new FILE_PATH
    @game_adapter = GameAdapter.new(self)
  end

  def choose_option
    output.introduction
    ask_choose_game_option
    choose_option
  end

  def start
    system 'clear'
    @game = registrator.game_registration
    start_game_process
  end

  def stats
    system 'clear'
    return output.no_stats unless File.exist? FILE_PATH

    output.show_stats
    decorated_stats = decorator.stats_beautify statistics.sort_statistics
    decorated_stats.each_with_index do |user, index|
      puts output.rating + index.next.to_s
      user.each { |key, value| puts "#{key} #{value}" }
      puts '=' * 25
    end
  end

  def rules
    system 'clear'
    output.show_rules
  end

  def leave
    output.bye
    exit true
  end

  def start_game_process
    system 'clear'
    until game.lose?
      show_current_state
      ask_choose_command_in_game_process
    end
    game_adapter.lost game
  end

  private

  def show_current_state
    puts output.show_difficulty + game.difficulty.kind.to_s
    puts output.show_attempts + game.difficulty.current_attempts.to_s
    puts output.show_hints + game.difficulty.current_hints.to_s
  end
end
