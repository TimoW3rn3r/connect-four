require './lib/game'
require './lib/save'

class ConnectFour
  include Save

  attr_reader :saved_games

  def initialize
    @saved_games = read_saved_games
  end

  def choose_saved_game
    print 'Enter game name to load: '
    name = gets.chomp
    if saved_games.keys.include?(name)
      saved_games[name]
    else
      puts 'Not found!'
      choose_saved_game
    end
  end

  def load_saved_game
    puts 'Games Found:'
    saved_games.each_key { |name| puts name }
    choose_saved_game
  end

  def game_choice
    choice = $stdin.getch
    case choice
    when '1'
      Game.new
    when '2'
      load_saved_game
    else
      puts 'Invalid Input'
      game_choice
    end
  end

  def start
    if saved_games.empty?
      game = Game.new
    else
      puts '1. Start new game'
      puts '2. Load saved game'
      game = game_choice
    end

    game.start
  end
end

c4 = ConnectFour.new
c4.start
