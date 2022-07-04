require './lib/constants'
require './lib/position'

class Board
  include Constants
  include BoxBuilders

  attr_reader :positions, :rows, :columns, :last_position
  attr_accessor :current_column, :next_symbol

  def initialize(rows = ROWS, columns = COLUMNS)
    @rows = rows
    @columns = columns
    @positions = []
    @last_position = nil
    @current_column = 1
  end

  def create_positions
    1.upto(rows) do |row|
      1.upto(columns) do |column|
        coordinate = [column, row]
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

  def change_column(value)
    @current_column = 1 + (columns + current_column + value - 1) % columns
  end

  def show_falling_symbol
    print '  '
    1.upto(columns) do |column|
      if column == current_column
        print "#{next_symbol}\n"
        break
      else
        print ' ' * 4
      end
    end
  end

  def draw_row(row)
    print BOX_VERTICAL
    1.upto(columns) do |column|
      coordinates = [column, row]
      print " #{fetch(coordinates).value} #{BOX_VERTICAL}"
    end
    print "\n"
  end

  def draw_box_top
    print BOX_TOP_LEFT
    1.upto(columns - 1) do
      print ' ' * 3
      print BOX_T_DOWN
    end
    print ' ' * 3
    print BOX_TOP_RIGHT
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
    show_falling_symbol
    draw_box_top
    1.upto(rows) do |row|
      draw_row(row)
    end
    draw_box_bottom
  end

  def wrong_input
    puts 'Invalid input'
    false
  end

  def drop(symbol)
    rows.downto(1) do |row|
      coordinates = [current_column, row]
      position = fetch(coordinates)
      return wrong_input if position.nil?
      next unless position.empty?

      position.fill(symbol)
      return @last_position = position
    end
    wrong_input
  end

  def reset
    @positions = []
  end
end
