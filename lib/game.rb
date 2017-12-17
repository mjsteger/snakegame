require_relative 'snake'
require_relative 'board'
require_relative 'point'
require 'curses'

class IllegalStateError < StandardError; end

class Game
  attr :board, :snake
  def initialize
    @board = Board.new
    @snake = Snake.new(board.initialize_snake)
  end

  def play
    food = board.random_position
    Kernel.loop do
      change = Curses.getch
      snake.process_direction(change)
      begin
        food = snake.tick(food)
        raise unless board.is_legal?(snake.positions)
      rescue IllegalStateError
        raise 'You died!'
      end
      food ||= board.random_position
      board.draw(snake: snake, fruit: food)
      sleep 0.1
    end
  end
end
