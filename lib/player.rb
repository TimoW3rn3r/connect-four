require './lib/constants'

class Player
  attr_reader :name, :symbol, :color
  attr_accessor :score

  def initialize(name = nil, symbol = nil, color = nil)
    @name = name
    @symbol = symbol
    @color = color
    @score = 0
  end

  def piece
    symbol.send(color)
  end

  def win_statement
    "#{name}(#{piece}) WINS!"
  end
end
