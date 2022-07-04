# require './lib/constants'
# require './lib/position'
require './lib/board'
require './lib/player'
require 'io/console'

class Game
  include Constants
  include Symbols

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
    board.next_symbol = player.colored_symbol
  end

  def choose_symbol
    symbols = PIECES.values
    symbols.each_with_index do |symbol, index|
      puts "    #{index} => #{symbol}"
    end
    print "  Choose symbol(0-#{symbols.length - 1})>> "
    choice = gets.chomp.to_i
    symbols.fetch(choice, symbols.sample)
  end

  def choose_color
    COLORS.each_with_index do |color, index|
      puts "    #{index} => #{color}"
    end
    print "  Choose color(0-#{COLORS.length - 1})>> "
    choice = gets.chomp.to_i
    COLORS.fetch(choice, COLORS.sample)
  end

  def add_players
    2.times do |i|
      puts "Player##{i + 1}"
      print '  Enter player name>> '
      name = gets.chomp
      symbol = String(choose_symbol)
      color = choose_color
      add_player(name, symbol, color)
    end
    set_current_player(players.sample)
  end

  def toggle_player_turn
    player = if current_player == players[0]
               players[1]
             else
               players[0]
             end
    set_current_player(player)
  end

  def declare_winner(symbol)
    players.each do |player|
      next unless player.colored_symbol == symbol

      puts "#{player.name} WINS!"
      player.score += 1
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
    DIRECTIONS.each_value do |value|
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

  def handle_input
    loop do
      case $stdin.getch
      when "\r" then break
      when '['
        case $stdin.getch
        when 'D' then board.change_column(-1)
        when 'C' then board.change_column(1)
        end
      when '/'
        case $stdin.getch
        when 'q' then exit
        when 's' then save
        end
      end
      display
    end
  end

  def play_round
    board.create_positions
    add_players if players.empty?
    display

    loop do
      handle_input
      next unless board.drop(current_player.colored_symbol)

      toggle_player_turn
      display
      break if game_over?
    end

    display
  end

  def start
    loop do
      board.reset
      play_round
      print 'Play again(y/n): '
      break unless gets.chomp.downcase == 'y'
    end
  end

  def help
    puts 'C O N N E C T - F O U R',
         "  Connect 4 pieces(row, column, diagonal) to win\n",
         '  Inputs: ',
         '    Change: ← →    Drop: <Enter>',
         "    Exit: /q       Save: /s\n\n"
  end

  def display_scores
    players.each do |player|
      print player.name
      print "(#{player.colored_symbol}): "
      print player.score
      print '    '
    end
    print "\n"
  end

  def display
    system('clear')
    help
    display_scores
    board.draw
  end

  def save
  end
end
