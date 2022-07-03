class Position
  include Symbols

  attr_reader :value, :coordinates

  def initialize(coordinates)
    @value = EMPTY
    @coordinates = coordinates
  end

  def fill(symbol)
    @value = symbol
  end

  def empty?
    value == EMPTY
  end

  def to_s
    value
  end
end