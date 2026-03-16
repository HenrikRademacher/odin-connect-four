# frozen_string_literal: true

require_relative 'lib/board'

def launch
  puts 'Starting game. Player1 starts with yellow, Player2 plays red.'
  game_board = Board.new
  turn_order(game_board) until game_board.game_won
  final_message(game_board)
end

def turn_order(game_board)
  puts game_board.deliver_printstring
  col = get_player_input(game_board, 'y')
  game_board.append_column(col, 'y')
  return if game_board.game_won

  puts game_board.deliver_printstring
  col = get_player_input(game_board, 'r')
  game_board.append_column(col, 'r')
end

def get_player_input(game_board, content)
  col = -1
  col = sanitized_player_input(game_board, content) until col >= 0
  col
end

def sanitized_player_input(game_board, content)
  puts "\nPlease select a column from 0 to 6 to insert #{content}."
  col = gets.chomp.to_i
  col if game_board.column_available?(col)
end

def final_message(game_board)
  puts "Winner found!\n"
  puts game_board.deliver_printstring
end

launch
