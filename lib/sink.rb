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

    end
  end

end
