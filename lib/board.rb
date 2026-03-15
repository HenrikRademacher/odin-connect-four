# frozen_string_literal: true

# Gameboard for Connect-Four
class Board
  attr_accessor :contents

  def initialize
    @contents = Array.new(7) { Array.new(6, '_') }
  end

  def fill_cell(col, row, content)
    @contents[col][row] = content if cell_empty?(col, row)
  end

  def cell_empty?(col, row)
    @contents[col][row] == '_'
  end
end
