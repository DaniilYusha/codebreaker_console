# frozen_string_literal: true

class RegistratorService
  attr_reader :output

  def initialize
    @output = OutputService.new
  end

  def game_registration
    game = Codebreaker::Game.new create_user, create_difficulty
    game if game.valid?
  end

  private

  def create_user
    @output.enter_name
    input = gets.chomp
    user = Codebreaker::User.new input
    return user if user.valid?

    puts show_entities_error user unless user.valid?
    create_user
  end

  def create_difficulty
    @output.enter_difficulty
    input = gets.chomp
    difficulty = Codebreaker::Difficulty.new input
    return difficulty if difficulty.valid?

    puts show_entities_error difficulty unless difficulty.valid?
    create_difficulty
  end

  def show_entities_error(obj)
    raise obj.errors.last unless obj.valid?
  rescue obj.errors.last => e
    puts e.message
  end
end
