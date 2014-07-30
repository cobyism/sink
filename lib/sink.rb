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

    def git
      @git ||= Git.open(Dir.pwd)
    end

    def setup_sync
      if dir_is_syncable(Dir.pwd)
        # Open up this git repo, and save the NWO for future usage.
        nwo = Sink.nwo_of_origin(git.remotes)
        puts "Syncing this folder with the #{nwo} repository on GitHub."
      else
        puts "Not a git repo, sorry!"
        exit
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
