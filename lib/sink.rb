require 'rubygems'
require 'git'
require 'octokit'
require 'dotenv'

class Sink

  class << self
    def load_config
      puts "Loading GitHub access token…"
      Dotenv.load "~/.sinkconfig"
      puts "Done."
    end

    def setup_sync
      if dir_is_syncable(Dir.pwd)
      else
      end
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

end
