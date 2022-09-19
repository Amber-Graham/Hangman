require 'pry-byebug'

class Hangman
binding.pry
  def inititalize
    @word = random_word
    @display_hidden_word = "_" * random_word.length
    @guesses = []
    @guesses_left = 12
  end

  def game_welcome
    puts "
    Welcome to Hangman!
    You will have up to 12 guesses to figure out the mystery word!"
    game_selection_input = nil
    until game_selection_input == '1' or game_selection_input == '2'
      puts "Would you like to play a new game or continue an old save?
      [1] New Game
      [2] Saved Game"
      game_selection_input = gets.chomp
    end
    case game_selection_input
    when '1'
      game_start
    when '2'
      if File.exists?("file", 'w') #i think
        load_saved_game
        game_start
      else
        puts "You do not have a file saved, you must play first!"
      end
    end
  end

  private

  def load_saved_game
    #YAML info here
    #File.open 
    # @word = yaml.hash[:word] ==> or something like this to pull the info
    # do it for each thing we initialize
  end

  def save_game
    #YAML info here
    #File.open and would be set to write the info in?
    # :word = @word
    # :display_hidden_word = @display_hidden_word 
    # :current_turn = @current_turn
    # :guesses = @guesses
  end

  def game_start
    player_won = false
    while @guesses_left != 0
      puts @display_hidden_word
      puts "Guesses Remaining: #{guesses_left}"
      puts "Enter a letter: "
      letters = gets.chomp.downcase!
      if letters == "save"
        save_game
        next
      end
      break if letters == "exit"
      update_word if letters
      player_won = player_won?
      break if player_won
    end
    puts "Game over, the secret word was: #{@word}." if @guesses_left == 0
    play_again
  end

  def random_word
    file = IO.readlines('google-10000-english-no-swears.txt')
    word = ''
    word = file[Random.rand(100..1000)].chomp 
      until word.length.between?(5,12)
    end
  end

  def update_word(letters)
    current_display = "#{display_hidden_word}"
    if letters.length == 1
      @display_hidden_word.length.times do |i|
        @display_hidden_word[i] = letters if @word[i].downcase == letters
      end
    else
      @display_hidden_word
    end
  end

  def player_won?
    unless @display_hidden_word.include?("_")
      puts "Congratulations! You guessed the secret word!"
      true
    end
    play_again
  end
      

  def play_again
    input = "" 
    until input == "Y" or input == "N"
      puts "Would you like to play again? (Y/N):\n"
      input = gets.chomp.upcase
    end
    case input
    when "Y"
      game_start
    when "N"
      puts "See you soon!"
    end
  end

  def guess_count
    @guesses_left -= 1
  end

Hangman.new