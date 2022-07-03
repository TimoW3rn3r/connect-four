require './lib/constants'
require './lib/position'
require './lib/board'
require './lib/player'

class Game
  include Constants

  attr_reader :board, :players, :current_player

  def initialize
    @board = Board.new
    @players = []
    @current_player = nil
  end

  def add_player(name, symbol, color)
    players.push(Player.new(name, symbol, color))
  end

  def set_current_player(player)
    @current_player = player
  end

  def add_players
    2.times do |i|
      puts "Player##{i + 1}"
      print "\tEnter player name>> "
      name = gets.chomp
      print "\tEnter player symbol>> "
      symbol = gets[0]
      print "\tColors available: red, green, blue, yellow\n"
      print "\tEnter symbol color>> "
      color = gets.chomp
      add_player(name, symbol, color)
    end
    set_current_player(players.sample)
  end

  def toggle_player_turn
    if current_player == players[0]
      set_current_player(players[1])
    else
      set_current_player(players[0])
    end
  end

  def declare_winner(symbol)
    players.each do |player|
      next unless player.colored_symbol == symbol

      puts "#{player.name} WINS!"
      break
    end
  end

  def check_neighbor(position, direction)
    next_coordinates = position.coordinates.zip(direction).map(&:sum)
    next_position = board.fetch(next_coordinates)
    return 0 if next_position.nil?
    return 0 if position.value != next_position.value

    1 + check_neighbor(next_position, direction)
  end

  def game_over?
    last_position = board.last_position
    DIRECTIONS.each do |_key, value|
      forward, backward = value
      connected = check_neighbor(last_position, forward) +
                  1 +
                  check_neighbor(last_position, backward)
      if connected >= 4
        declare_winner(last_position.value)
        return true
      end
    end
    false
  end

  def start
    board.create_positions
    add_players
    board.draw

    loop do
      print "\n[#{current_player.name}] Enter the column>> "
      column = gets.chomp.to_i
      next unless board.drop(current_player.colored_symbol, column)

      toggle_player_turn
      board.draw
      break if game_over?
    end
  end
end
