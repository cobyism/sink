#!/usr/bin/env ruby
require 'rubygems'
require 'git'
require 'octokit'
require 'dotenv'

Dotenv.load

nwo = ""

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

if dir_is_syncable(Dir.pwd)

  g = Git.open(Dir.pwd)
  github = Octokit::Client.new(:access_token => ENV["GITHUB_TOKEN"])
  puts github.repo g.remotes['']

  while true do

    g.status.each do |file|
      if file.untracked || !file.type.nil?

        if file.type == "D"
          g.remove file.path
        else
          g.add file.path
        end

        message =
          if file.untracked
            # Untracked files don’t have a type of 'A' before being staged,
            # and at the point we run `status` we haven’t staged anything yet.
            "Auto-sync: A - #{file.path}"
          else
            "Auto-sync: #{file.type} - #{file.path}"
          end

        puts "#{message}. Syncing…"
        g.commit message
        g.push('origin')
        puts "Done."
      end
    end

    g.pull('origin')

    sleep 1
  end
end
