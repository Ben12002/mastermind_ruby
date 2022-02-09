module Colors
  COLORS = ["RED", "GREEN", "BLUE", "YELLOW", "PINK", "PURPLE"]

  def valid_color?(color)
    color = color.downcase
    COLORS.include?(color)
  end

end

#=====================================================================================================================================
class Game

  include Colors

  def initialize
    @turn = 1 # goes up to 12
    @red_pin = 0 # no. of pins of correct color and placement
    @white_pin = 0 # no. of pins of correct color but wrong placement
    @guess = ["","","",""]
    @secret_code = ["","","",""]
    @board = Board.new
  end

  # game loop
  def play

  end

  # game is over if:
  #  - guess given is equal to the secret code and isn't in the initialized state
  #  - or turn limit has been reached and secret code hasn't been guessed
  def game_over?
    (@guess == @secret_code) && !secret_code.include?("") || @turn = 12
  end

  # input for move has to be in the format "color1 color2 color3 color4"
  def valid_input(in)
    (in.split(" ").length == 4) || valid_guess(in)
  end

  # guess has to contain each color at most once and must be a valid color
  def valid_guess(guess)

    valid_colors = guess.all? do |color| 
      color = color.upcase
      COLORS.include?(color)
    end

    unique_colors = (guess.uniq.length == 4)

    valid_colors && unique_colors
  end

  # allows player to submit a guess
  def make_guess(guess)
    
    if valid_input(guess)
      @board.add_to_board(guess)
      true
    else
      false
    end
  end

  # decides how many white and red pins to display
  def rate_guess

  end
end
#=====================================================================================================================================
class Board

  include Colors

  def initialize
    @arr = []
  end

  def add_to_board(guess)
    @arr.push(guess)
  end
    
end
#=====================================================================================================================================
class Player

end
#=====================================================================================================================================

def play_game
  game = Game.new()
  game.play
  play_again
end

def play_again
  # After game ends, give option to play again or end program
  answer = ""
  while answer != "y" && answer != "n"
    puts "would you like to play again? (y/n)"
    answer = gets.chomp

    if answer == "n"
      puts "Shutting down......."
    elsif answer != "y"
      puts "invalid answer"
    else
      puts "Another game!"
      play_game
    end
  end
end

#===============================================================================

play_game