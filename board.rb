class Board
  class CursesBoard
    attr_accessor :win
    def initialize
      Curses.stdscr.keypad(true)
      @win = Curses::Window.new(height, width, 0, 0)
      Curses.stdscr.keypad(true)
      @win.box('|', '-')
      Curses.init_screen
      Curses.curs_set(0)
      Curses.crmode
      Curses.noecho
      Curses.stdscr.nodelay = true
    end
  end
  attr_accessor :width, :height
  def initialize(width: 60, height: 30)
    @top_right = Point.new(width, 0)
    @bottom_left = Point.new(0, height)

    @width = width
    @height = height
  end

  def initialize_snake
    x, y = @width / 2, @height / 2
    # TODO Make this adjust based on survival likelihood
    return { starting_position: Point.new(x, y), vector: Point.new(0, 1) }
  end

  def is_legal?(positions)
    positions.all? do |position|
      position.x > @bottom_left.x &&
        position.x < @top_right.x - 1 &&
        position.y > @top_right.y &&
        position.y < @bottom_left.y - 1
    end
  end

  def draw(snake:, fruit:)
    @curses_board ||= CursesBoard.new(@height, @width)
    @curses_board.win.clear
    @curses_board.win.box('|', '-')
    Curses.init_screen

    current_pos = snake.head
    @curses_board.win.setpos(*current_pos.graphics_to_a)
    @curses_board.win << snake.head_direction
    snake.body.each do |body_part|
      @curses_board.win.setpos(*body_part.graphics_to_a)
      @curses_board.win << 'o'
    end
    @curses_board.win.setpos(*fruit.graphics_to_a)
    @curses_board.win << '🍎'
    @curses_board.win.refresh
  end

  def random_position
    Point.new(Random.rand(width - 2) + 1, Random.rand(height - 2) + 1)
  end
end
