class Point
  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Point.new(x + other.x, y + other.y)
  end

  def to_a
    [x, y]
  end

  # Yay y,x standard!
  def graphics_to_a
    [y, x]
  end

  def hash
    [x.hash, y.hash].hash
  end

  def eql?(other)
    x == other.x && y == other.y
  end

  def ==(other)
    eql?(other)
  end

  def -(other)
    Point.new(x - other.x, y - other.y)
  end
end
