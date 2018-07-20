# Usage: ruby process.rb git-repo-url.git repo-name
#
# Will clone the repo and extract the log for the timeline of 2017
require 'bundler/setup'
require 'active_support/time'
require 'git'
#require 'byebug'
require 'virtus'
require './numstat_commit'
require './csv_generator'

include DateAndTime::Calculations

GIT_REPOS = './repos'.freeze
CSV_EXPORTS = './exports'.freeze

FROM = 'JAN 1 2017'.freeze
TO   = 'DEC 31 2017'.freeze

# Save time fo debugging to store the log in a txt file
DEBUG = false

## Create directories if they don't exist
[GIT_REPOS, CSV_EXPORTS].each do |directory|
  Dir.mkdir(directory) unless File.directory?(directory)
end

repo = ARGV[0]
name = ARGV[1]

if repo.nil? || name.nil?
  puts 'usage: ruby process.rb repo name'
  raise 'no repo or name provided'
end

puts "Pulling '#{name}' repo: #{repo}"

# NOTE: handle submodule repos, maybe?
existing_repo = GIT_REPOS + '/' + name
unless File.directory?(existing_repo)
  Git.clone(repo, name, path: GIT_REPOS)
end

puts 'Analyzing the logs...'
debug_file = 'debug_raw_output.txt'
if File.exists?(debug_file) && DEBUG
  logs = File.read(debug_file)
else
  logs = `cd #{existing_repo} && git log --no-merges --numstat --since "#{FROM}" --until "#{TO}"`

  if DEBUG
    File.open(debug_file, 'w') { |f|
      f.write logs
    }
  end
end

commits = []
current = nil
# First line of a block is always the commit log line, with SHA, first sentence message
logs.split("\n").each { |line|
  next if line == "" || line[/^-\t-/]
  if current.nil?
    current = NumstatCommit.new(commit: line)
  else
    unless line[/^\d*\t\d*\t/] # not a numstat line
      commits << current
      current = NumstatCommit.new(commit: line)
    else
      current.changes << line
    end
  end

}
commits << current # store last processed

puts 'Generating CSV...'
file = CsvGenerator.call(
  output_dir: CSV_EXPORTS,
  repo: repo,
  name: name,
  commits: commits
)

puts "Done, generated CSV file: #{file}"
