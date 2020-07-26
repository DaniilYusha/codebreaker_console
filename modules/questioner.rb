# frozen_string_literal: true

module Questioner
  YES = 'y'
  NO = 'n'
  START_COMMAND = 'start'
  RULES_COMMAND = 'rules'
  STATS_COMMAND = 'stats'
  EXIT_COMMAND = 'exit'
  HINT_COMMAND = 'hint'

  def ask_about_new_game
    output.again
    input = gets.chomp
    case input
    when YES then game_adapter.start_new_game game
    when NO then leave
    else output.unexpected_command
    end
    ask_about_new_game
  end

  def ask_about_save_results
    output.save
    input = gets.chomp
    case input
    when YES then return statistics.store game
    when NO then return
    else output.unexpected_command
    end
    ask_about_save_results
  end

  def ask_choose_game_option
    output.commands_description
    input = gets.chomp
    case input
    when START_COMMAND then start
    when RULES_COMMAND then rules
    when STATS_COMMAND then stats
    when EXIT_COMMAND then leave
    else output.unexpected_command
    end
  end

  def ask_choose_command_in_game_process
    output.enter_guess
    input = gets.chomp
    case input
    when HINT_COMMAND then game_adapter.hint game
    when EXIT_COMMAND then leave
    else game_adapter.check_guess(game, input)
    end
  end
end
