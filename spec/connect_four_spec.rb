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
      expect(my_board.fetch([2, 7]).value).to eq('X')
      expect(my_board.fetch([2, 6]).value).to eq('Y')
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

describe Game do
  subject(:my_game) { described_class.new }
  let(:my_player) { double(Player, name: 'PlayerX', colored_symbol: '@') }

  describe '#add_player' do
    it 'creates new player object with given name, symbol, color' do
      allow(Player).to receive(:new)
      expect(Player).to receive(:new).with('PlayerNo1', '%', 'yellow').once
      my_game.add_player('PlayerNo1', '%', 'yellow')
    end

    it 'adds the new player to the players list' do
      expect(my_game.players).to receive(:push).once
      my_game.add_player('PlayerNo2', 'T', 'gray')
    end
  end

  describe '#set_current_player' do
    it 'sets current player to the given player' do
      my_game.set_current_player('player1')
      expect(my_game.current_player).to eq('player1')
    end
  end

  describe '#add_players' do
    before do
      allow(my_game).to receive(:print)
      allow(my_game).to receive(:puts)
    end

    it 'sends #add_player to the game' do
      allow(my_game).to receive(:add_player)
      allow(my_game).to receive(:gets).and_return('')
      expect(my_game).to receive(:add_player).twice
      my_game.add_players
    end

    it 'randomly sets first player to move' do
      allow(my_game).to receive(:gets)
        .and_return('player1', '$', 'red',
                    'player2', '@', 'green')
      my_game.add_players
      expect(my_game.players).to include(my_game.current_player)
    end
  end

  describe '#toggle_player_turn' do
    it 'toggles current player' do
      allow(my_game).to receive(:players).and_return(%w[player1 player2])
      my_game.set_current_player('player2')

      my_game.toggle_player_turn
      expect(my_game.current_player).to eq('player1')
    end
  end

  describe '#declare winner' do
    it 'declares winner' do
      # allow(my_game).to receive(:puts)

      allow(my_game).to receive(:players).and_return([my_player])
      # allow(my_player).to receive(:colored_symbol).and_return('@')
      win_statement = 'PlayerX WINS!'

      expect(my_game).to receive(:puts).with(win_statement)
      my_game.declare_winner('@')
    end
  end

  describe '#check_neighbor' do
    context 'returns number of neighbors with same ' \
            'value for given position' do
      it 'works in row' do
        my_board = my_game.board
        my_board.create_positions

        row_elements = [[2, 3], [3, 3], [4, 3], [5, 3]]
        row_elements.each do |coordinates|
          position = my_board.fetch(coordinates)
          position.fill('x')
        end

        # check for left direction
        direction = [-1, 0]
        my_position = my_board.fetch([4, 3])
        expect(my_game.check_neighbor(my_position, direction)).to eq(2)

        # check for right direction
        direction = [1, 0]
        expect(my_game.check_neighbor(my_position, direction)).to eq(1)
      end

      it 'works in column' do
        my_board = my_game.board
        my_board.create_positions
        column_elements = [[1, 2], [1, 3], [1, 4], [1, 5], [1, 6]]
        column_elements.each do |coordinates|
          position = my_board.fetch(coordinates)
          position.fill('@')
        end

        # check for up direction
        direction = [0, 1]
        my_position = my_board.fetch([1, 2])
        expect(my_game.check_neighbor(my_position, direction)).to eq(4)

        # check for down direction
        direction = [0, -1]
        expect(my_game.check_neighbor(my_position, direction)).to eq(0)
      end

      it 'works in diagonal' do
        my_board = my_game.board
        my_board.create_positions
        diagonal_elements = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]
        diagonal_elements.each do |coordinates|
          position = my_board.fetch(coordinates)
          position.fill('#')
        end

        # check for upper-right direction
        direction = [1, 1]
        my_position = my_board.fetch([3, 3])
        expect(my_game.check_neighbor(my_position, direction)).to eq(2)

        # check for upper-left direction
        direction = [-1, 1]
        expect(my_game.check_neighbor(my_position, direction)).to eq(0)
      end
    end
  end

  describe '#game_over?' do
    context 'when game ends in a row win' do
      it 'returns true' do
        my_board = my_game.board
        my_board.create_positions
        row_win_position_combo = [[3, 2], [3, 3], [3, 4], [3, 5]]
        row_win_position_combo.each do |coordinates|
          position = my_board.fetch(coordinates)
          position.fill('x')
        end
        allow(my_board).to receive(:last_position).and_return(my_board.fetch([3, 4]))

        expect(my_game.game_over?).to be_truthy
      end
    end

    context 'when game ends in a column win' do
      it 'returns true' do
        my_board = my_game.board
        my_board.create_positions
        column_win_position_combo = [[1, 1], [1, 2], [1, 4], [1, 5], [1, 6], [1, 7]]
        column_win_position_combo.each do |coordinates|
          position = my_board.fetch(coordinates)
          position.fill('x')
        end
        allow(my_board).to receive(:last_position).and_return(my_board.fetch([1, 4]))

        expect(my_game.game_over?).to be_truthy
      end
    end

    context 'when game ends in a diagonal win' do
      it 'returns true' do
        my_board = my_game.board
        my_board.create_positions
        column_win_position_combo = [[1, 6], [2, 5], [3, 4], [4, 3]]
        column_win_position_combo.each do |coordinates|
          position = my_board.fetch(coordinates)
          position.fill('x')
        end
        allow(my_board).to receive(:last_position).and_return(my_board.fetch([1, 6]))

        expect(my_game.game_over?).to be_truthy
      end
    end
  end
end
