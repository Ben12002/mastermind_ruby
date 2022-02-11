module Colors
  COLORS = ["RED", "GREEN", "BLUE", "YELLOW", "PINK", "PURPLE"]
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
    @turn = 1
  end

  # user plays as code guesser, Computer makes secret code
  def play_guesser
    generate_secret_code

    while !game_over?
      valid = false

      while !valid
        puts @board.to_s
        print "(Turn #{@turn}) Your guess: "
        answer = gets.chomp.upcase
        if make_guess(answer)
          valid = true
        end
      end

      if !guessed_code?
        rate_guess
      else
        puts "You cracked the code!"
        break
      end

      @turn += 1
    end
  end

  # user makes secret code, Computer guesses code
  def play_code_creator
    valid = false

    # Entering secret code
    while !valid
      print "Enter your secret code: "
      answer = gets.chomp.upcase
      if enter_secret_code(answer)
        valid = true
        puts "Secret code set! #{@secret_code}"
      end
    end

    #Computer guesses up to 12 times
    while !game_over?
      puts @board.to_s
      generate_guess
      if !guessed_code?
        rate_guess
      else
        puts "Computer cracked the code!"
        break
      end
      @turn += 1
    end
    
  end

  def generate_guess
    # bindly guessing
    @guess = COLORS.shuffle[0..3]
    @board.add_to_board(@guess)
  end


  # game is over if:
  #  - guess given is equal to the secret code and isn't in the initialized state
  #  - or turn limit has been reached and secret code hasn't been guessed
  def game_over?
    guessed_code? || (@turn > 12)
  end

  def guessed_code?
    (@guess == @secret_code) && !(@secret_code.include?(""))
  end

  # input for move has to be in the format "color1 color2 color3 color4"
  def valid_input(input)
    (input.split(" ").length == 4) && valid_guess(input.split(" "))
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
      @guess = guess.split(" ")
      @board.add_to_board(@guess)
      true
    else
      false
    end
  end

  # User enters secret code
  def enter_secret_code(code)

    if valid_input(code)
      @secret_code = code.split(" ")
      true
    else
      false
    end
  end

  # Computer generates secret code
  def generate_secret_code
    @secret_code = COLORS.shuffle[0..3]
    puts "SECRET CODE: #{@secret_code}"
  end

  # decides how many white and red pins to display
  def rate_guess
  #  correct_colors = @guess.intersection(@secret_code).length
  #  correct_position = 0

  #  @guess.intersection(@secret_code).each do |color|
  #     if @secret_code.index(color) == @guess.index(color)
  #     correct_position += 1
  #     correct_colors -= 1
  #     end
  #   end
  #   @white_pin = correct_colors
  #   @red_pin = correct_position

  #   puts "red pins: #{@red_pin}, white pins: #{@white_pin}"

  @white_pin = @guess.intersection(@secret_code).length
  @red_pin = 0
   @guess.intersection(@secret_code).each do |color|
      if @secret_code.index(color) == @guess.index(color)
        @red_pin += 1
        @white_pin -= 1
      end
    end
    puts "red pins: #{@red_pin}, white pins: #{@white_pin}"
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

  def to_s
    if @arr.length == 0
      return "|No guesses made yet!|"
    else
      out_str = ""
      @arr.each do |guess|
        out_str += "[#{guess[0]}, #{guess[1]}, #{guess[2]}, #{guess[3]}]\n"
      end
    end
    out_str
  end
end
#=====================================================================================================================================
def play_game
  game = Game.new
  mode = set_up

  if mode == "g"
    game.play_guesser
  elsif mode == "c"
    game.play_code_creator
  end
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

def set_up
  
  answer = ""
  while (answer != "g") && (answer != "c")
    puts "guesser or code creator? (g/c): "
    answer = gets.chomp
  end
  answer
end
#===============================================================================

play_game