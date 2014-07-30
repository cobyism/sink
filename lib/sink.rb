require 'rubygems'
require 'git'
require 'octokit'
require 'dotenv'

class Sink

  attr_accessor :dir, :git, :github, :nwo, :status

  def initialize
    Dotenv.load "~/.sinkconfig"
    puts "Configuration loaded: ✔"

    @dir = Dir.pwd
    @git = Git.open(@dir)
    @github = Octokit::Client.new(:access_token => ENV["GITHUB_TOKEN"])

    if dir_is_syncable?
      @nwo = @git.remotes.select { |r| r.name == 'origin' }
        .first.url
        .gsub(/https:\/\/github.com\//, '')
        .gsub(/\.git/, '')
      puts "GitHub remote detected: ✔"
    else
      puts "Not a git repo, sorry! Exiting…"
      exit
    end

    watch
  end

  def watch
    puts "Watching for changes…"

    while true
      if unstaged_changes?
        @git.add(all: true)
        @git.commit(commit_message)
        @git.push('origin')
        puts "Latest changes pushed!"
      end

      if remote_head_sha != local_head_sha
        @git.pull('origin')
        # `git pull --rebase` # No method available for this in the git gem :(
      end
      sleep 2
    end
  end

  private

  def remote_head_sha
    @github.branch(@nwo, 'master')[:commit][:sha]
  end

  def local_head_sha
    @git.log.first.sha
  end

  def status
    @status ||= `git status -sb`
  end

  def recheck_status
    @status = `git status -sb`
  end

  def status_changes
    status.split("\n")[1..-1]
  end

  def unstaged_changes?
    recheck_status
    status_changes != []
  end

  def change_list
    "- #{status_changes.join("\n- ")}"
  end

  def commit_message
    # Recheck status after staging everything so we can commit renames.
    # i.e. R oldname -> newname instead of D oldname + A newname.
    recheck_status
    count = status_changes.count
    message = "#{count} file#{'s' if count > 1} changed.\n#{change_list}"
    puts message
    "Auto-sync: #{message}"
  end

  def dir_is_syncable?
    begin
      origin_exists = false
      @git.remotes.each do |remote|
        origin_exists = true if !origin_exists && remote.name == 'origin' && !remote.url.match(/github/).nil?
      end
      puts "Directory is syncable: ✔"
      origin_exists
    rescue ArgumentError
      false
    end
  end

end
