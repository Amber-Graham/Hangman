require 'pry-byebug'

class Hangman
  def initialize
    @word = get_word
    @display_hidden_word = "_" * @word.length
    @guesses_left = 12
    @guesses = []
    game_welcome
  end

  def game_welcome
    puts "
    Welcome to Hangman!
    You will have up to 12 guesses to figure out the mystery word! 
    You can save your game at any time by typing 'save' or exit the game by typing 'exit'."
    game_selection_input = ""
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
      if File.exists?()#file name -- will need to look into naming system)
        load_saved_game
        game_start
      else
        puts "You do not have a file saved, you must play first!"
      end
    end
  end

  #def load_saved_game
    #YAML info here
    #File.open 
    # @word = yaml.hash[:word] ==> or something like this to pull the info
    # do it for each thing we initialize
  #end

  #def save_game
    #YAML info here
    #File.open and would be set to write the info in?
    # :word = @word
    # :display_hidden_word = @display_hidden_word 
  #end

  def game_start
    player_won = false
    while @guesses_left != 0
      puts @display_hidden_word
      puts "Guesses Remaining: #{@guesses_left}\n Guessed letters: #{@guesses}\n Enter a letter: "
      letter = gets.chomp
      if letter == "save"
        puts "Your game has been saved!"
        save_game
        next
      end
      break if letter == "exit"
      update_word(letter) if letter
      player_won = player_won?
      break if player_won
    end
    if @guesses_left == 0
      puts "Game over, the secret word was: #{@word}." 
      play_again
    end
  end

  def get_word
    File.readlines('google-10000-english-no-swears.txt').select { |word| word.length.between?(6,13) }.sample.strip
  end

  def update_word(letter)
    letter.strip.downcase!
    current_display = @display_hidden_word.clone
    if @word.include? letter
      @display_hidden_word.length.times do |i|
        @display_hidden_word[i] = letter if @word[i] == letter
      end
    elsif letter.match?(/[^a-z]/) || letter.length > 1 || letter.length < 1
      puts "Please only enter one letter."
    else 
      @guesses << letter
      @guesses_left -= 1
    end
  end

  def player_won?
    unless @display_hidden_word.include?("_")
      puts "Congratulations! You guessed the secret word: #{@word}!"
      true
      play_again
    end
  end     

  def play_again
    while true
      puts "Would you like to play again? (Y/N):\n"
      case gets.strip.upcase
        when "Y"
          game_welcome
        when "N"
          puts "See you soon!"
          break
        end
    end
  end
end



my_game = Hangman.new