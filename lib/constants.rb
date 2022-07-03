module Constants
  ROWS = 8
  COLUMNS = 8
  DIRECTIONS = { row: [[-1, 0], [1, 0]],
                 column: [[0, -1], [0, 1]],
                 diagonal1: [[1, 1], [-1, -1]],
                 diagonal2: [[-1, 1], [1, -1]] }.freeze
end

module BoxBuilders
  BOX_VERTICAL = "\u2551".freeze
  BOX_HORIZONTAL = "\u2550".freeze
  BOX_BOTTOM_LEFT = "\u255a".freeze
  BOX_BOTTOM_RIGHT = "\u255d".freeze
  BOX_T_UP = "\u2569".freeze
end

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m".freeze
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end
end

module Symbols
  EMPTY = "\u25ef".freeze
  WHITE = "\u25cf".freeze
  RED = WHITE.red
  GREEN = WHITE.green
  YELLOW = WHITE.yellow
  BLUE = WHITE.blue
end
