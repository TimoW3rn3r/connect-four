require './lib/player'

describe Player do
  subject(:my_player) { described_class.new }

  describe '#colored_symbol' do
    it 'returns colored version of symbol' do
      allow(my_player).to receive(:symbol).and_return('@')
      allow(my_player).to receive(:color).and_return(:green)

      expect(my_player.colored_symbol).to eq('@'.green)
    end

    it 'returns normal symbol when given invalid color' do
      allow(my_player).to receive(:symbol).and_return('@')
      allow(my_player).to receive(:color).and_return(:not_green)

      expect(my_player.colored_symbol).to eq('@')
    end
  end
end