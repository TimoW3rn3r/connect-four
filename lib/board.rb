class Board
  include Constants
  include BoxBuilders

  attr_reader :positions, :rows, :columns, :last_position

  def initialize(rows = ROWS, columns = COLUMNS)
    @rows = rows
    @columns = columns
    @positions = []
    @last_position = nil
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

  def draw_row(row)
    print BOX_VERTICAL
    1.upto(columns) do |column|
      coordinates = [column, row]
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

  def wrong_input
    puts 'Invalid input'
    false
  end

  def drop(symbol, column)
    rows.downto(1) do |row|
      coordinates = [column, row]
      position = fetch(coordinates)
      return wrong_input if position.nil?
      next unless position.empty?

      position.fill(symbol)
      return @last_position = position
      # return coordinates
    end
    wrong_input
  end
end