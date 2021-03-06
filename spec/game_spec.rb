require './lib/game'
require './lib/constants'
include Symbols
include Constants

describe Game do
  subject(:my_game) { described_class.new }
  let(:my_player) { double(Player, name: 'PlayerX', piece: '@', score: 0, win_statement: nil) }

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
      my_game.set_current_player(my_player)
      expect(my_game.current_player).to be(my_player)
    end

    it 'sends :next_symbol= to the board' do
      my_board = my_game.board
      symbol = my_player.piece
      expect(my_board).to receive(:next_symbol=).with(symbol).once
      my_game.set_current_player(my_player)
    end
  end

  describe '#choose_symbol' do
    it 'returns the symbol for the user input' do
      allow(my_game).to receive(:puts)
      allow(my_game).to receive(:print)
      allow(my_game).to receive(:gets).and_return('3')
      stored_symbol = PIECES.values[3]
      expect(my_game.choose_symbol).to eq(stored_symbol)
    end
  end

  describe '#choose_color' do
    it 'returns the color for the user input' do
      allow(my_game).to receive(:puts)
      allow(my_game).to receive(:print)
      allow(my_game).to receive(:gets).and_return('3')
      stored_color = COLORS[3]
      expect(my_game.choose_color).to eq(stored_color)
    end
  end

  describe '#add_players' do
    before do
      allow(my_game).to receive(:print)
      allow(my_game).to receive(:puts)
      allow(my_game).to receive(:set_current_player)
      allow(my_game).to receive(:gets).and_return('')
      allow(my_game).to receive(:add_player)
    end

    it 'sends :add_player to the game' do
      expect(my_game).to receive(:add_player).twice
      my_game.add_players
    end

    it 'sends :set_current_player with random player'\
       ' as argument to the game' do
      expect(my_game).to receive(:set_current_player)
      my_game.add_players
    end
  end

  describe '#toggle_player_turn' do
    it 'toggles current player' do
      allow(my_game).to receive(:players).and_return(%w[player1 player2])
      allow(my_game).to receive(:current_player).and_return('player2')

      expect(my_game).to receive(:set_current_player).with('player1').once
      my_game.toggle_player_turn
    end
  end

  describe '#declare winner' do
    before do
      allow(my_player).to receive(:score=)
      allow(my_game).to receive(:players).and_return([my_player])
      allow(my_game).to receive(:puts)
      allow(my_game).to receive(:display)
    end

    it 'sends :win_statement to winner' do
      expect(my_player).to receive(:win_statement)
      my_game.declare_winner('@')
    end

    it 'adds 1 score to the winner' do
      expect(my_player).to receive(:score=).with(1)
      my_game.declare_winner('@')
    end
  end

  describe '#count_neighbors' do
    it 'returns number of connected pieces ' \
            'in given direction' do
      my_board = my_game.board
      my_board.create_positions

      row_elements = [[2, 3], [3, 3], [4, 3], [5, 3]]
      row_elements.each do |coordinates|
        position = my_board.fetch(coordinates)
        position.fill('x')
      end
      my_position = my_board.fetch([4, 3])

      direction = [-1, 0]
      expect(my_game.count_neighbors(my_position, direction)).to eq(2)

      direction = [1, 0]
      expect(my_game.count_neighbors(my_position, direction)).to eq(1)
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
        diagonal_win_position_combo = [[1, 6], [2, 5], [3, 4], [4, 3]]
        diagonal_win_position_combo.each do |coordinates|
          position = my_board.fetch(coordinates)
          position.fill('x')
        end
        allow(my_board).to receive(:last_position).and_return(my_board.fetch([1, 6]))

        expect(my_game.game_over?).to be_truthy
      end
    end
  end

  describe '#handle_input' do
    before do
      allow(my_game).to receive(:display)
    end

    it 'returns true when pressed enter' do
      allow($stdin).to receive(:getch).and_return("\r")
      expect(my_game.handle_input).to eq(true)
    end

    context 'when left key is pressed' do
      it 'sends :change_column to the board with "-1" as argument' do
        allow($stdin).to receive(:getch).and_return('[', 'D')

        expect(my_game.board).to receive(:change_column).with(-1).once
        my_game.handle_input
      end
    end

    context 'when right key is pressed' do
      it 'sends :change_column to the board with "1" as argument' do
        allow($stdin).to receive(:getch).and_return('[', 'C')

        expect(my_game.board).to receive(:change_column).with(1).once
        my_game.handle_input
      end
    end

    it 'sends :save_game to the game when "/s" is pressed' do
      allow($stdin).to receive(:getch).and_return('/', 's')

      expect(my_game).to receive(:save_game).once
      my_game.handle_input
    end

    it 'sends :exit to the game when "/q" is pressed' do
      allow($stdin).to receive(:getch).and_return('/', 'q')

      expect(my_game).to receive(:exit).once
      my_game.handle_input
    end
  end
end
