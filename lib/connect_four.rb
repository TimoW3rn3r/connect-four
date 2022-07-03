module Constants
  ROWS = 8
  COLUMNS = 8
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
  WHITE = "\u2b24".freeze
  RED = WHITE.red
  GREEN = WHITE.green
  YELLOW = WHITE.yellow
  BLUE = WHITE.blue
end

class Position
  include Symbols

  attr_reader :value, :coordinates

  def initialize(coordinates)
    @value = EMPTY
    @coordinates = coordinates
  end

  def fill(symbol)
    @value = symbol
  end

  def empty?
    value == EMPTY
  end

  def to_s
    value
  end
end

class Board
  include Constants
  include BoxBuilders

  attr_reader :positions, :rows, :columns

  def initialize(rows = ROWS, columns = COLUMNS)
    @rows = rows
    @columns = columns
    @positions = []
  end

  def create_positions
    1.upto(rows) do |row|
      1.upto(columns) do |column|
        coordinate = [row, column]
        position = Position.new(coordinate)
        positions.push(position)
      end
    end
  end

  def fetch(coordinates)
    positions.each do |position|
      return position if position.coordinates == coordinates
    end
    nil
  end

  def draw_row(row)
    print BOX_VERTICAL
    1.upto(columns) do |column|
      coordinates = [row, column]
      print " #{fetch(coordinates)} #{BOX_VERTICAL}"
    end
    print "\n"
  end

  def draw_box_bottom
    print BOX_BOTTOM_LEFT
    1.upto(columns - 1) do
      print BOX_HORIZONTAL * 3
      print BOX_T_UP
    end
    print BOX_HORIZONTAL * 3
    puts BOX_BOTTOM_RIGHT
  end

  def draw
    1.upto(rows) do |row|
      draw_row(row)
    end
    draw_box_bottom
  end

  def drop(symbol, column)
    rows.downto(1) do |row|
      coordinates = [row, column]
      position = fetch(coordinates)
      next unless position.empty?

      position.fill(symbol)
      return position.coordinates
    end
    false
  end
end
