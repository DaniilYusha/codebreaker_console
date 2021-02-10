# frozen_string_literal: true

module Questioner
  def ask_about_new_game
    output.again
    input = gets.chomp
    case input
    when output.yes_answer then game_adapter.start_new_game game
    when output.no_answer then leave
    else output.unexpected_command
    end
    ask_about_new_game
  end

  def ask_about_save_results
    output.save
    input = gets.chomp
    case input
    when output.yes_answer then return statistics.store game
    when output.no_answer then return
    else output.unexpected_command
    end
    ask_about_save_results
  end

  def ask_choose_game_option
    output.commands_description
    input = gets.chomp
    case input
    when output.start_command then start
    when output.rules_command then rules
    when output.stats_command then stats
    when output.exit_command then leave
    else output.unexpected_command
    end
  end

  def ask_choose_command_in_game_process
    output.enter_guess
    input = gets.chomp
    case input
    when output.hint_command then game_adapter.hint game
    when output.exit_command then leave
    else game_adapter.check_guess(game, input)
    end
  end
end
