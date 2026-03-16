# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    subject(:my_board) { described_class.new }
    it('creates 7 columns') do
      expect(my_board.contents.length).to eq 7
    end
    it('creates 7 arrays') do
      expect(my_board.contents).to all(be_an(Array))
    end
    it('creates 6 rows per column') do
      my_lengths = my_board.contents.map(&:length)
      expect(my_lengths).to all(eq 6)
    end
  end

  describe '#fill_cell' do
    subject(:my_board) { described_class.new }
    before do
      my_board.fill_cell(4, 0, 'y')
    end
    it 'fills a cell with y' do
      expect(my_board.contents[4][0]).to eq 'y'
    end
    it 'only fills an empty cell' do
      my_board.fill_cell(4, 0, 'r')
      expect(my_board.contents[4][0]).to eq 'y'
    end
    it 'sets last filled attribute' do
      my_board.fill_cell(4, 0, 'r')
      expect(my_board.instance_variable_get(:@last_changed)).to eq [4, 0]
    end
  end

  describe '#cell_empty?' do
    subject(:my_board) { described_class.new }
    before do
      my_board.fill_cell(3, 0, 'r')
    end
    it 'checks for a filled cell' do
      expect(my_board.cell_empty?(3, 0)).to eq false
    end
    it 'checks for an empty cell' do
      expect(my_board.cell_empty?(5, 0)).to eq true
    end
  end

  describe '#column_available?' do
    subject(:my_board) { described_class.new }
    before do
      my_board.fill_cell(0, 5, 'y')
    end
    it 'checks for a filled row' do
      expect(my_board.column_available?(0)).to eq false
    end
    it 'checks for an empty row' do
      expect(my_board.column_available?(1)).to eq true
    end
  end

  describe '#append_column' do
    subject(:my_board) { described_class.new }
    before do
      my_board.fill_cell(0, 0, 'y')
      my_board.fill_cell(0, 1, 'y')
      my_board.fill_cell(1, 0, 'y')
    end
    it 'fills row 3 if filled twice' do
      expect(my_board.cell_empty?(0, 2)).to eq true
      my_board.append_column(0, 'r')
      expect(my_board.cell_empty?(0, 2)).to eq false
    end
    it 'fills row 2 if filled once' do
      expect(my_board.cell_empty?(1, 1)).to eq true
      my_board.append_column(1, 'r')
      expect(my_board.cell_empty?(1, 1)).to eq false
    end
    it 'fills row 1 if unfilled' do
      expect(my_board.cell_empty?(2, 0)).to eq true
      my_board.append_column(2, 'r')
      expect(my_board.cell_empty?(2, 0)).to eq false
    end
  end

  describe '#inbound?' do
    subject(:my_board) { described_class.new }

    it 'checks for inbound coords' do
      expect(my_board.inbound?(3, 5)).to eq true
    end
    it 'checks for negative col' do
      expect(my_board.inbound?(-1, 3)).to eq false
    end
    it 'checks for greater col' do
      expect(my_board.inbound?(7, 0)).to eq false
    end
    it 'checks for negative row' do
      expect(my_board.inbound?(2, -2)).to eq false
    end
    it 'checks for greater row' do
      expect(my_board.inbound?(5, 11)).to eq false
    end
  end

  describe '#gather_similar' do
    subject(:my_board) { described_class.new }
    before do
      my_board.fill_cell(0, 3, 'r')
      my_board.fill_cell(0, 4, 'r')
      my_board.fill_cell(1, 3, 'y')
      my_board.fill_cell(2, 3, 'y')
      my_board.fill_cell(2, 4, 'r')
      my_board.fill_cell(1, 4, 'r')
    end
    it 'discovers three r leftwards' do
      my_board.fill_cell(3, 4, 'r')
      expect(my_board.gather_similar(-1, 0)).to eq 3
    end
    it 'discovers two r downwards' do
      my_board.fill_cell(0, 5, 'r')
      expect(my_board.gather_similar(0, -1)).to eq 2
    end
    it 'discovers two r diagonally' do
      my_board.fill_cell(2, 5, 'r')
      expect(my_board.gather_similar(-1, -1)).to eq 2
    end
  end

  describe '#investigate_status' do
    subject(:my_board) { described_class.new }
    before do
      my_board.fill_cell(0, 3, 'r')
      my_board.fill_cell(0, 4, 'r')
      my_board.fill_cell(1, 3, 'y')
      my_board.fill_cell(2, 3, 'y')
      my_board.fill_cell(2, 4, 'r')
      my_board.fill_cell(1, 4, 'r')
    end
    it 'sees vertical win' do
      my_board.fill_cell(0, 2, 'r')
      my_board.fill_cell(0, 5, 'r')
      expect(my_board.instance_variable_get(:@game_won)).to eq false
      my_board.investigate_status
      expect(my_board.instance_variable_get(:@game_won)).to eq true
    end
    it 'sees horizontal win' do
      my_board.fill_cell(4, 3, 'y')
      my_board.fill_cell(3, 3, 'y')
      expect(my_board.instance_variable_get(:@game_won)).to eq false
      my_board.investigate_status
      expect(my_board.instance_variable_get(:@game_won)).to eq true
    end
    it 'sees diagonal win' do
      my_board.fill_cell(1, 1, 'y')
      my_board.fill_cell(2, 2, 'y')
      my_board.fill_cell(4, 4, 'y')
      my_board.fill_cell(3, 3, 'y')
      expect(my_board.instance_variable_get(:@game_won)).to eq false
      my_board.investigate_status
      expect(my_board.instance_variable_get(:@game_won)).to eq true
    end
    it 'sees diagonal win' do
      my_board.fill_cell(2, 2, 'y')
      my_board.fill_cell(4, 0, 'y')
      my_board.fill_cell(3, 1, 'y')
      expect(my_board.instance_variable_get(:@game_won)).to eq false
      my_board.investigate_status
      expect(my_board.instance_variable_get(:@game_won)).to eq true
    end
    it 'sees no win' do
      my_board.fill_cell(2, 2, 'r')
      my_board.fill_cell(4, 0, 'y')
      my_board.fill_cell(3, 1, 'y')
      expect(my_board.instance_variable_get(:@game_won)).to eq false
      my_board.investigate_status
      expect(my_board.instance_variable_get(:@game_won)).to eq false
    end
  end
end
