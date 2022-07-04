require './lib/game'
require './lib/save'

class ConnectFour
  include Save

  def start
    game = nil
    loop do
      puts '1. Start new game'
      puts '2. Load saved game'

      choice = $stdin.getch
      case choice
      when '1'
        game = Game.new
      when '2'
        saved_games = read_saved_games
        if saved_games.empty?
          puts 'No saved game found'
          puts 'Starting New Game'
          game = Game.new
        else
          puts 'Games Found:'
          saved_games.each_key { |game| puts game }
          loop do
            print 'Enter game name to load: '
            name = gets.chomp
            if saved_games.keys.include?(name)
              game = saved_games[name]
              break
            end
          end
        end
      else
        puts 'Invalid input'
        next
      end
      break
    end

    game.start
  end
end

c4 = ConnectFour.new
c4.start
