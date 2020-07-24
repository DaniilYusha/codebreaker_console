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
    @output.again
    input = gets.chomp
    start_new_game if input == YES
    exit if input == NO
    @output.unexpected_command
    ask_about_new_game
  end

  def ask_about_save_results
    @output.save
    input = gets.chomp
    return @statistics.store game if input == YES
    return if input == NO

    @output.unexpected_command
    ask_about_save_results
  end

  def ask_choose_game_option
    @output.commands_description
    input = gets.chomp
    case input
    when START_COMMAND then start
    when RULES_COMMAND then rules
    when STATS_COMMAND then stats
    when EXIT_COMMAND then leave
    else @output.unexpected_command
    end
  end

  def ask_choose_command_in_game_process
    @output.enter_guess
    input = gets.chomp
    case input
    when HINT_COMMAND then hint
    when EXIT_COMMAND then leave
    else check_guess(input)
    end
  end
end
