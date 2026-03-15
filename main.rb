# frozen_string_literal: true

def launch
  puts 'Starting game. Player1 starts with yellow, Player2 plays red.'
  game_board = Board.new
  turn_order until game_board.won?
  final_message
end
