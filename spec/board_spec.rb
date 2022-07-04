require './lib/board'

describe Board do
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

  describe '#change_column' do
    it 'shifts the column by given value' do
      expect{my_board.change_column(1)}.to change{my_board.current_column}.by(1)
    end

    it 'works with negative value' do
      my_board.instance_variable_set(:@current_column, 5)
      expect{my_board.change_column(-1)}.to change{my_board.current_column}.by(-1)
    end

    it 'wraps the value between 1 and maximum columns' do
      my_board.instance_variable_set(:@columns, 6)
      my_board.instance_variable_set(:@current_column, 2)
      my_board.change_column(5)
      expect(my_board.current_column).to eq(1)
    end
  end

  describe '#drop' do
    it 'stacks the given symbol in the specified column' do
      allow(my_board).to receive(:current_column).and_return(2)
      my_board.drop('X')
      my_board.drop('Y')
      expect(my_board.fetch([2, 7]).value).to eq('X')
      expect(my_board.fetch([2, 6]).value).to eq('Y')
    end

    it 'returns false when the column is full' do
      allow(my_board).to receive(:current_column).and_return(3)

      # fill the column
      7.times do
        my_board.drop('@')
      end

      # drop to the filled column
      expect(my_board.drop('#')).to be_falsy
    end
  end

  describe '#reset' do
    it 'resets board positions' do
      my_board.drop('X')
      expect(my_board.positions).not_to be_empty

      my_board.reset
      expect(my_board.positions).to be_empty
    end
  end
end
