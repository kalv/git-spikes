require 'virtus'
require 'byebug'

# Helper class to help parse out information of the commit log line
class CommitDetails
  include Virtus::Model
  attribute :commits, Array[String]
  attribute :meta_data, String

  def delta
    insertions.to_i - deletions.to_i
  end

  def insertions
    meta_data[/(\d+) insertions/, 1]
  end

  def deletions
    meta_data[/(\d+) deletions/, 1]
  end

  def details
    commits.map {|section|
      section
    }.join("\n")
  end

  def sha
    commits.first[/^(\S*)\s/, 1]
  end
end
