# frozen_string_literal: true

# Gameboard for Connect-Four
class Board
  attr_accessor :contents

  def initialize
    @contents = Array.new(7) { Array.new(6, '_') }
    @last_changed = [nil, nil]
    @game_won = false
  end

  def fill_cell(col, row, content)
    return unless cell_empty?(col, row)

    @contents[col][row] = content
    @last_changed = [col, row]
  end

  def cell_empty?(col, row)
    @contents[col][row] == '_'
  end

  def column_available?(col)
    @contents[col][5] == '_'
  end

  def append_column(col, content)
    row = 0
    row += 1 until cell_empty?(col, row)
    fill_cell(col, row, content)
  end

  def inbound?(col, row)
    col.between?(0, 6) && row.between?(0, 5)
  end

  def gather_similar(col_grow, row_grow, gathered = 0)
    col = @last_changed[0]
    row = @last_changed[1]
    content = @contents[col][row]
    while inbound?(col + col_grow, row + row_grow)
      @contents[col + col_grow][row + row_grow] == content ? gathered += 1 : break
      col += col_grow
      row += row_grow
    end
    gathered
  end

  def investigate_status
    @game_won = true if gather_similar(0, -1) >= 3 # vertical win
    @game_won = true if (gather_similar(-1, 0) + gather_similar(1, 0)) >= 3 # horizontal win
    @game_won = true if (gather_similar(-1, -1) + gather_similar(1, 1)) >= 3 # diagonal forward win
    @game_won = true if (gather_similar(1, -1) + gather_similar(-1, 1)) >= 3 # diagonal backward win
  end

  def deliver_printstring
    lines[] = @contents.map { |line| line.join(' ') }
    lines.join('\n')
  end
end
