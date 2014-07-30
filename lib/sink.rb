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
      end

      # Is the local repo ahead?
      # Is the remote repo ahead?
      sleep 2
    end
  end

  private

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
    # Fetch status again after staging everything so we can do renames
    # i.e. R oldname -> newname instead of D oldname + A newname.
    recheck_status
    count = status_changes.count
    message = "Auto-sync: #{count} file#{'s' if count > 1} changed.\n#{change_list}"
    puts message
    message
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

  # def do_initial_sync
  #   begin
  #     # Are we ahead?
  #     # Are we behind?
  #     # Are there unstaged changes to start with?
  #
  #     puts "Searching for latest commit…"
  #     begin
  #       # Get the current head sha of the default branch for later checks
  #       remote_head_sha = @github.branch(nwo, "master")[:commit][:sha]
  #       local_head_sha = @git.log.first.sha
  #
  #       puts "Latest remote commit is #{remote_head_sha}."
  #       puts "Latest local commit is #{local_head_sha}."
  #
  #       if remote_head_sha != local_head_sha
  #         puts "Local repo is out of sync with remote. Fixing that…"
  #         pull_rebase = `git pull --rebase origin master`
  #         g.push('origin')
  #         puts "Done."
  #       end
  #     end while remote_head_sha != local_head_sha
  #   rescue
  #     puts "Looks like sink doesn’t have access to this private repo."
  #     puts "Have you set your GitHub token in ~/.sinkconfig?"
  #     exit
  #   end
  # end

    # class << self
    #   def dir_is_syncable(dir)
    #     begin
    #       g = Git.open(dir)
    #       origin_exists = false
    #       g.remotes.each do |remote|
    #         origin_exists = true if !origin_exists && remote.name == 'origin' && !remote.url.match(/github/).nil?
    #       end
    #       origin_exists
    #     rescue ArgumentError
    #       false
    #     end
    #   end
    #
    #   def nwo_of_origin(remotes)
    #     remotes.select { |r| r.name == 'origin' }
    #       .first.url
    #       .gsub(/https:\/\/github.com\//, '')
    #       .gsub(/\.git/, '')
    #   end
    #
    # end

end
