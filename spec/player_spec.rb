require './lib/player'

describe Player do
  subject(:my_player) { described_class.new }

  describe '#piece' do
    it 'returns colored version of symbol' do
      allow(my_player).to receive(:symbol).and_return('@')
      allow(my_player).to receive(:color).and_return(:green)

      expect(my_player.piece).to eq('@'.green)
    end
  end

  describe '#win_statement' do
    it 'returns player win statement' do
      allow(my_player).to receive(:name).and_return('PlayerX')
      allow(my_player).to receive(:piece).and_return('@')

      expect(my_player.win_statement).to eq('PlayerX(@) WINS!')
    end
  end
end
