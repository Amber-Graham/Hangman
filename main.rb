require 'pry-byebug'

#when run, the script should pull a 5-12 letter word from the .txt
#open the .txt file for reading and read the line
#open a new file for writing
#skip any lines that are less than 5 or greater than 12
#print the rest to a new file
#close the both files

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
    save_games_data
  end
end

def get_random_word
  file = IO.readlines('google-10000-english-no-swears.txt')
  word = ''
  word = file[Random.rand(9894)].chomp until word.length.between?(5,12)
  puts word
end

def game_start
  

game_welcome