require 'csv'
require './service'

# Generate a CSV file from the commits supplied
class CsvGenerator
  include Service
  attribute :output_dir, String
  attribute :repo, String
  attribute :name, String
  attribute :commits, Array[CommitDetails]

  def call
    filename = "#{output_dir}/#{name}.csv"
    CSV.open(filename, 'wb', write_headers: true, headers: headers) do |csv|
      commits.each do |commit|
        begin
          csv << csv_row(commit)
        rescue => e
          puts "Error generating the CSV: #{e}"
          #byebug
        end
      end
    end
    filename
  end

  private

  def headers
    %w[CommitUrl Delta Insertions Deletions Details raw]
  end

  def csv_row(commit)
    [
      url_to_commit(commit),
      commit.delta,
      commit.insertions,
      commit.deletions,
      commit.details,
      commit.commits.join("\n")
    ]
  end

  def url_to_commit(commit)
    "#{repo.gsub(/^git@github\.com:/, 'https://github.com/').gsub(/\.git/, '')}/commit/#{commit.sha}"
  end
end
