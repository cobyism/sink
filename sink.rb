#!/usr/bin/env ruby
require 'rubygems'
require 'rugged'

def dir_is_syncable(dir)
  begin
    repo = Rugged::Repository.new(dir)
    origin_exists = false
    repo.remotes.each do |remote|
      origin_exists = true if !origin_exists && remote.name == 'origin' && remote.url.match(/github/)
    end
    origin_exists
  rescue Rugged::RepositoryError
    puts "Not a git repo, sorry!"
    false
  end
end

while dir_is_syncable(Dir.pwd) do
  repo = Rugged::Repository.new(Dir.pwd)

  repo.status do |file, status_data|
    puts "#{file} has status: #{status_data.inspect}"
  end

  # if has_changes(output)
    # puts "changes are present!"

  #   for entry in output do
  #     path = get_path(entry)
  #     message = "auto-sink: #{change_type(entry)} #{path}"
  #     `git add #{path}`
  #     `git commit -m "#{message}"`
  #     `git pull --rebase`
  #     `git push`
  #   end
  #
  # else
  #   `git pull`

  # end

  sleep 2
end
