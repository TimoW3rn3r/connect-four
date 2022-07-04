require 'yaml'

module Save
  SAVE_FILE = 'saved.yaml'

  def read_saved_games
    begin
      YAML.load(File.read(SAVE_FILE), aliases: true,
                permitted_classes: [Game, Board, Position, Player, Symbol])
    rescue Errno::ENOENT
      {}
    end
  end

  def save_game
    saved = read_saved_games
    print 'Enter save name: '
    name = gets.chomp
    saved[name] = self
    File.open(SAVE_FILE,'w') do |file|
      file.puts YAML.dump(saved)
    end
    puts "Saved under '#{name}'"
    $stdin.getch
  end
end
