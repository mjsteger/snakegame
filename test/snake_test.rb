require 'test_helper'

describe Snake do
  let(:point_one) { Point.new(5, 5) }
  let(:point_two) { Point.new(3, 5) }
  let(:snake) { Snake.new(starting_position: Point.new(5, 5), vector: Point.new(1, 1)) }
  it 'tests handle_food with food' do
    food = snake.handle_food(point_one, point_one)
    assert food.nil?
    assert snake.body.length > 1
  end
  it 'tests handle_food without food' do
    food = snake.handle_food(point_one, point_two)
    assert food == point_one
    snake.body.length.must_equal 0
  end
end
