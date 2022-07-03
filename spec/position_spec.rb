require './lib/position'

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
