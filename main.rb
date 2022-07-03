require './lib/connect_four'

board = Board.new
board.create_positions
25.times do 
  column = rand(7) + 1
  symbol = ['@'.red, 'X'.green].sample
  board.drop(symbol, column)
end

# board.draw

game = Game.new
game.start