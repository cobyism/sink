#!/usr/bin/env ruby
require 'rubygems'
require 'git'

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

while dir_is_syncable(Dir.pwd) do
  g = Git.open(Dir.pwd)

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

  # repo.status do |file, status_data|
    # puts "#{file} has status: #{status_data.inspect}"
  # end

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

  sleep 1
end
