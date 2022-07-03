require './lib/connect_four'

describe Position do
  subject(:my_position) { described_class.new([0, 0]) }
  
  describe '#fill' do
    it 'fills the position with specified symbol' do
      my_position.fill('@')
      expect(my_position.value).to eq('@')
    end
  end

  describe '#empty?' do
    it 'returns true when the position is empty' do
      expect(my_position.empty?).to be_truthy
    end

    it 'returns false when the position is already filled' do
      my_position.fill('#')
      expect(my_position.empty?).to be_falsy
    end
  end
end

describe Board do
  # let(:position) { double(Position) }
  subject(:my_board) { described_class.new(7, 5) }
  
  before do
    my_board.create_positions
  end

  describe '#create_positions' do
    it 'creates the empty positions' do
      expect(my_board.positions.size).to eq(7 * 5)

      random_position = my_board.positions.sample
      expect(random_position.empty?).to be_truthy
    end
  end

  describe '#fetch' do
    it 'returns the position at the given coordinates' do
      random_position = my_board.positions.sample
      coordinates = random_position.coordinates

      expect(my_board.fetch(coordinates)).to be(random_position)
    end

    it 'returns nil when given out of bound coordinates' do
      expect(my_board.fetch([100, 1])).to be_nil
    end
  end

  describe '#drop' do
    it 'stacks the given symbol in the specified column' do
      my_board.drop('X', 2)
      my_board.drop('Y', 2)
      expect(my_board.fetch([7, 2]).value).to eq('X')
      expect(my_board.fetch([6, 2]).value).to eq('Y')
    end

    it 'returns false when the column is full' do
      # fill the column
      7.times do
        my_board.drop('@', 3)
      end

      # drop to the filled column
      expect(my_board.drop('#', 3)).to be_falsy
    end
  end
end