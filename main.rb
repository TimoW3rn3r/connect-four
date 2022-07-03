require './lib/connect_four'

board = Board.new
board.create_positions
15.times do 
  position = board.positions.sample
  symbol = ['@'.red, 'X'.green].sample
  position.fill(symbol)
end

board.draw