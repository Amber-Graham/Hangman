require 'pry-byebug'

#when run, the script should pull a 5-12 letter word from the .txt
#open the .txt file for reading and read the line
#open a new file for writing
#skip any lines that are less than 5 or greater than 12
#print the rest to a new file
#close the both files

def game_welcome
  puts "Welcome to Hangman!"
end

def get_random_word
  file = IO.readlines('google-10000-english-no-swears.txt')
  word = ''
  word = file[Random.rand(9894)].chomp until word.length.between?(5,12)
  puts word
end

game_welcome