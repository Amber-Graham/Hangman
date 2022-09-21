require 'pry-byebug'
require_relative 'file_data'
require 'yaml'

class Hangman
  attr_accessor :word, :display_hidden_word, :guesses, :guesses_left
  include Data

  def initialize
    @word = get_word
    @display_hidden_word = "_" * @word.length
    @guesses_left = 12
    @guesses = []
    game_welcome
  end

  def game_welcome
    puts "Welcome to Hangman!\nYou will have up to 12 guesses to figure out the mystery word!\nYou can save your game at any time by typing 'save' or exit the game by typing 'exit'."
    game_selection_input = ""
    until game_selection_input == '1' or game_selection_input == '2'
      puts "Would you like to play a new game or continue an old save?\n[1] New Game\n[2] Saved Game"
      game_selection_input = gets.chomp
    end
    case game_selection_input
    when '1'
      game_start
    when '2'
        load_game
      else
        puts "You do not have a file saved, you must play first!"
      end
    end
  end

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
      delete_file
      play_again
    end
  end     

  def play_again
    while true
      puts "Would you like to play again? (Y/N):\n"
      case gets.strip.upcase
        when "Y"
          Hangman.new
        when "N"
          break
        end
      end
    end


my_game = Hangman.new