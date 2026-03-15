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
end
