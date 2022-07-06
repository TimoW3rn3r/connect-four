require './lib/board'
require './lib/player'
require './lib/save'
require 'io/console'

class Game
  include Constants
  include Symbols
  include Save

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
    board.next_symbol = player.piece
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

  def player_name(player_number)
    puts "Player##{player_number + 1}"
    print '  Enter player name>> '
    gets.chomp
  end

  def add_players
    2.times do |i|
      name = player_name(i)
      symbol = choose_symbol
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
      next unless player.piece == symbol

      player.score += 1
      display
      puts player.win_statement
      break
    end
  end

  def count_neighbors(position, direction)
    next_coordinates = position.coordinates.zip(direction).map(&:sum)
    next_position = board.fetch(next_coordinates)
    return 0 if next_position.nil?
    return 0 if position.value != next_position.value

    1 + count_neighbors(next_position, direction)
  end

  def connected(position, direction)
    backward_direction = direction.map(&:-@)
    count_neighbors(position, direction) +
      1 +
      count_neighbors(position, backward_direction)
  end

  def game_draw?
    board.positions.each do |position|
      return false if position.empty?
    end
    puts 'GAME IS DRAW!'
    true
  end

  def game_won?
    last_position = board.last_position
    DIRECTIONS.each_value do |direction|
      next if connected(last_position, direction) < 4

      declare_winner(last_position.value)
      return true
    end
    false
  end

  def game_over?
    game_draw? || game_won?
  end

  def handle_escaped_input
    case $stdin.getch
    when 'D' then board.change_column(-1)
    when 'C' then board.change_column(1)
    end
    display
    false
  end

  def handle_command_input
    case $stdin.getch
    when 'q' then exit
    when 's' then save_game
    end
    false
  end

  def handle_input
    case $stdin.getch
    when "\r" then true
    when '[' then handle_escaped_input
    when '/' then handle_command_input
    end
  end

  def game_setup
    board.create_positions
    add_players
  end

  def reset
    board.reset
    board.create_positions
  end

  def play_round
    game_setup if players.empty?
    display

    loop do
      next until handle_input
      next unless board.drop(current_player.piece)

      toggle_player_turn
      display
      break if game_over?
    end
  end

  def play_again?
    print 'Play again(y/n): '
    gets.chomp.downcase == 'y'
  end

  def start
    play_round
    reset

    start if play_again?
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
      print "(#{player.piece}): "
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
end
