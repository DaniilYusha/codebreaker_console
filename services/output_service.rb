# frozen_string_literal: true

class OutputService
  def initialize
    I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
    I18n.default_locale = :en
  end

  def introduction
    puts I18n.t :introduction
  end

  def bye
    puts I18n.t :bye
  end

  def commands_description
    puts I18n.t :commands_description
  end

  def unexpected_command
    puts I18n.t :unexpected_command
  end

  def show_rules
    puts I18n.t :rules
  end

  def show_stats
    puts I18n.t :stats
  end

  def no_stats
    puts I18n.t :no_stats
  end

  def show_hint
    I18n.t :show_hint
  end

  def enter_name
    puts I18n.t :enter_name
  end

  def enter_difficulty
    puts I18n.t :enter_difficulty
  end

  def enter_guess
    puts I18n.t :enter_guess
  end

  def no_hints
    puts I18n.t :no_hints
  end

  def lose
    I18n.t :lose
  end

  def win
    I18n.t :win
  end

  def again
    puts I18n.t :again
  end

  def save
    puts I18n.t :save
  end

  def rating
    I18n.t :rating
  end

  def show_difficulty
    I18n.t :difficulty
  end

  def show_attempts
    I18n.t :attempts
  end

  def show_hints
    I18n.t :hints
  end
end
