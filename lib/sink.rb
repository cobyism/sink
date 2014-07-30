module Sink

  def load_config
    puts "Loading GitHub access token…"
    Dotenv.load "~/.sinkconfig"
    puts "Done."
  end

  def dir_is_syncable(dir)
    begin
      g = Git.open(dir)
      origin_exists = false
      g.remotes.each do |remote|
        origin_exists = true if !origin_exists && remote.name == 'origin' && !remote.url.match(/github/).nil?
      end
      origin_exists
    rescue ArgumentError
      puts "Not a git repo, sorry!"
      false
    end
  end

  def nwo_of_origin(remotes)
    remotes.select { |r| r.name == 'origin' }
      .first.url
      .gsub(/https:\/\/github.com\//, '')
      .gsub(/\.git/, '')
  end

end
