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
      if File.exists?()
        load_saved_game
        game_start
      else
        puts "You do not have a file saved, you must play first!"
      end
    end
  end

  def save_game
    Dir.mkdir 'output' unless Dir.exist? 'output'
    @filename = "#{random_name}_game.yaml"
    File.open("output/#{@filename}", "w") { |file| file.write save_to_yaml}
    puts display_saved_name
  end

  def random_name
    things = %w[cars spy ball baloon map unit bedroom work jellyfish aftermath weather guitar wrist thrill produce patch level opinion operation flame chickens]
    verbs = %w[like fold inform scab insult warn sip roar praise boast become handle shun sob fish pass forsake purify argue innovate]
    "#{things[rand(0-20)]}_#{verbs[rand(0-20)]}_#{rand(11..99)}"
  end

  def save_to_yaml
    YAML.dump(
      'word' => @word
      'guesses_left' => @guesses_left
      'display_hidden_word' => @display_hidden_word
      'guesses' => @guesses
    )
  end

  def find_saved_file
    show_file_list
    file_number = user_input(display_saved_prompt, /\d+|^exit$/)
    @saved_game = file_list[file_number.to_i -1] unless file_number == 'exit'
  end

  def show_file_list
    puts dispay_saved_games('#', 'File Name(s)')
    file_list.each_with_index do |name, index|
      puts display_saved_games((index + 1).to_s, name.to_s)
    end
  end

  def file_list
    files = []
    Dir.entries('output').each do |name|
      files << name if name.match(/(game)/)
    end
    files
  end

  def load_game
    find_saved_file
    load_saved_file
    player_turns
    File.delete("output/#{@saved_game}") if File.exist?("output/#{@saved_game}")
    end_game
  rescue StandardError
    puts display_load_error
  end

  def load_saved_file
    file - YAML.safe_load(File.read("output/#{@saved_game}"))
    @word = file['word']
    @solution = word.split(//)
    @available_letters = file['available_letters']
    @solved_letters = file['solved_letters']
    @incorrect_letters = file['incorrect_letters']
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
end



my_game = Hangman.new