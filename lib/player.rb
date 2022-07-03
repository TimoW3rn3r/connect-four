require './lib/constants'

class Player
  attr_reader :name, :symbol, :color

  def initialize(name = nil, symbol = nil, color = nil)
    @name = name
    @symbol = symbol
    @color = color
  end

  def colored_symbol
    %i[red green blue yellow].each do |available_color|
      return symbol.send(color) if
        String(color) == String(available_color)
    end
    symbol
  end
end
