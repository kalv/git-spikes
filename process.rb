require 'bundler/setup'
require 'active_support/time'
require 'git'
require 'byebug'
require 'virtus'
require './commit_details'
require './csv_generator'

include DateAndTime::Calculations

GIT_REPOS = './repos'.freeze
CSV_EXPORTS = './exports'.freeze

## Create directories if they don't exist
[GIT_REPOS, CSV_EXPORTS].each do |directory|
  Dir.mkdir(directory) unless File.directory?(directory)
end

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
  Git.clone(repo, name, path: GIT_REPOS)
end

puts 'Analyzing the logs...'
logs = `cd #{existing_repo} && git log --shortstat --since "JAN 1 2017" --until "DEC 31 2017"`

commits = []
current = nil
logs.split("\n").each { |line|
  current = CommitDetails.new if current.nil?

  if line[/insertions/]
    current.meta_data = line
    commits << current
    current = nil
    next
  end

  current.commits << line
}

puts 'Generating CSV...'
file = CsvGenerator.call(
  output_dir: CSV_EXPORTS,
  repo: repo,
  name: name,
  commits: commits
)

puts "Done, generated CSV file: #{file}"
