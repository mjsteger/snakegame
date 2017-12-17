require 'curses'
require 'forwardable'
require_relative 'point'
class Snake
  class PreviousVectorRecord
    attr_reader :vector, :remaining
    def initialize(vector, remaining)
      @vector = vector
      @remaining = remaining
    end

    def decrement
      @remaining -= 1
    end

    def increment
      @remaining += 1
    end

    def valid?
      @remaining > 0
    end
  end

  class BodyPart
    extend Forwardable
    def_delegators(:@position, :x, :y, :graphics_to_a)
    attr_accessor :position, :vector
    def initialize(position, vector)
      @position = position
      @vector = vector
    end
  end

  DIRECTION_HASH = {
    # We are in graphics land, so 0, 0 is the origin,
    # and the y axis goes down _positively_
    Curses::KEY_UP => Point.new(0, -1),
    Curses::KEY_DOWN => Point.new(0, 1),
    Curses::KEY_RIGHT => Point.new(1, 0),
    Curses::KEY_LEFT => Point.new(-1, 0)
  }
  attr_accessor :head, :body

  def initialize(starting_position:, vector:)
    @head = starting_position
    @vector = vector
    @current_direction = DIRECTION_HASH.invert[vector]
    @body = []
    @previous_vector_changes = {}
  end

  def positions
    [@head] + @body
  end

  def add_body_part
    if @body.empty?
      @body << BodyPart.new(@head - @vector, @vector)
    else
      @body << BodyPart.new(@body.last.position - @body.last.vector, @body.last.vector)
    end
    @previous_vector_changes.values.each(&:increment)
  end

  def handle_food(food, next_head_position)
    if next_head_position.eql? food
      2.times { add_body_part }
      return nil
    end
    food
  end

  def update_body
    @body.map do |part|
      if new_vector_record = @previous_vector_changes[part.position]
        part.vector = new_vector_record.vector
      end
      part.position = part.position + part.vector
    end
  end

  def tick(food)
    next_head_position = head + @vector
    raise IllegalStateError if body.any? {|part| part.position == next_head_position }
    food = handle_food(food, next_head_position)
    update_body
    @head = next_head_position
    @previous_vector_changes.values.each(&:decrement)
    @previous_vector_changes.select! { |key, val| val.valid? }
    food
  end

  def process_direction(direction)
    return if direction.nil?
    @current_direction = direction if DIRECTION_HASH.keys.include?(direction)
    @vector = DIRECTION_HASH[direction] || @vector
    5.times { add_body_part } if direction == 'a'
    @previous_vector_changes[head] = PreviousVectorRecord.new(@vector, @body.length + 1)
  end

  def head_direction
    case @current_direction
    when Curses::KEY_UP
      '^'
    when Curses::KEY_DOWN
      'v'
    when Curses::KEY_RIGHT
      '>'
    when Curses::KEY_LEFT
      '<'
    end
  end
end
