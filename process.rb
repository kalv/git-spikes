require 'bundler/setup'
require 'active_support/time'
require 'git'
require 'byebug'
require 'virtus'
require './commit_details'

include DateAndTime::Calculations

GIT_REPOS = './repos'.freeze

## Do the stuff
repo = ARGV[0]
name = ARGV[1]

if repo.nil? || name.nil?
  puts 'usage: ruby process.rb repo name'
  raise 'no repo or name provided'
end

puts "Pulling '#{name}' repo: #{repo}"

# TODO: handle submodule repos?
existing_repo = GIT_REPOS + '/' + name
unless File.directory?(existing_repo)
  g = Git.clone(repo, name, path: GIT_REPOS)
end

puts 'analyzing the logs'
logs = `cd #{existing_repo} && git log --shortstat --since "JAN 1 2017" --until "DEC 31 2017"`
commits = logs.split("\n\n").map { |line|
  CommitDetails.new(commit: line)
}.reject { |details|
  details.invalid?
}

puts "done"

byebug

puts "why this failing"
puts 1
p commits.first
