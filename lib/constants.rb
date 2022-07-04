# frozen_string_literal: true

module Constants
  ROWS = 8
  COLUMNS = 8
  COLORS = %i[red blue green yellow]
  DIRECTIONS = { row: [[-1, 0], [1, 0]],
                 column: [[0, -1], [0, 1]],
                 diagonal1: [[1, 1], [-1, -1]],
                 diagonal2: [[-1, 1], [1, -1]] }.freeze
end

module BoxBuilders
  BOX_TOP_LEFT = "\u250c"
  BOX_TOP_RIGHT = "\u2510"
  BOX_BOTTOM_LEFT = "\u2514"
  BOX_BOTTOM_RIGHT = "\u2518"
  BOX_VERTICAL = "\u2502"
  BOX_HORIZONTAL = "\u2500"
  BOX_T_DOWN = "\u252c"
  BOX_T_LEFT = "\u251c"
  BOX_T_RIGHT = "\u2524"
  BOX_T_UP = "\u2534"
  BOX_PLUS = "\u253c"
end

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
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
  EMPTY = ' '  # "\u25ef"
  PIECES = {
    circle: "\u25cf",
    solar_symbol: "\u2600",
    star: "\u2605",
    heart: "\u2665",
    diamond: "\u2666",
    club: "\u2663",
    spades: "\u2660",
    hammer_pick: "\u2692",
    die: "\u2680",
    bend: "\u2621",
    hazard: "\u2622"
  }
end
