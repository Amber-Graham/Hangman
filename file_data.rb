module Data
  def save_game
    Dir.mkdir 'output' unless Dir.exist? 'output'
    @filename = "#{random_name}_game.yaml"
    File.open("output/#{@filename}", "w") { |file| file.write save_to_yaml}
    puts "\n\nYour game is saved under the name: #{@filename}\n\n"
  end

  def random_name
    things = %w[cars spy ball baloon map unit bedroom work jellyfish aftermath weather guitar wrist thrill produce patch level opinion operation flame chickens]
    verbs = %w[like fold inform scab insult warn sip roar praise boast become handle shun sob fish pass forsake purify argue innovate]
    "#{things[rand(0-20)]}_#{verbs[rand(0-20)]}_#{rand(11..99)}"
  end

  def save_to_yaml
    YAML.dump(
      'word' => @word,
      'guesses_left' => @guesses_left,
      'display_hidden_word' => @display_hidden_word,
      'guesses' => @guesses
    )
  end

  def find_saved_file
    show_file_list
    file_number = user_input(display_saved_prompt, /\d+|^exit$/)
    @saved_game = file_list[(file_number.to_i)-1]
  end

  def user_input(prompt, regex)
    loop do
      print prompt
      input = gets.chomp
      input.match(regex) ? (return input) : "\nInvalid input!\n"
    end
  end

  def display_saved_prompt
    puts "\nEnter the game number that you would like to play.\n"
  end

  def show_file_list
    puts display_saved_games('#', 'File Name(s)')
    file_list.each_with_index do |name, index|
      puts display_saved_games((index + 1).to_s, name.to_s)
    end
  end

  def display_saved_games(num, name)
    puts "[#{num}] #{name}"
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
    File.delete("output/#{@saved_game}") if File.exist?("output/#{@saved_game}")
    game_start
  end

  def load_saved_file
    file = YAML.load(File.read("output/#{@saved_game}"))
    @word = file['word']
    @display_hidden_word = file['display_hidden_word']
    @guesses = file['guesses']
    @guesses_left = file['guesses_left']
  end
end