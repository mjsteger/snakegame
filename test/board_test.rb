require 'test_helper'

class BoardTest < Minitest::Test
  def board
    @board ||= Board.new(width: 20, height: 20)
  end

  def test_is_legal?
    refute board.is_legal?([Point.new(21, 21)])
    assert board.is_legal?([Point.new(15, 15)])
  end
end
