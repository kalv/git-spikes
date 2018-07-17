require 'virtus'
require 'byebug'

# Helper class to help parse out information of the commit log line
class CommitDetails
  include Virtus::Model
  attribute :commit, String

  def delta
    insertions.to_i - deletions.to_i
  end

  def insertions
    sections.first[/(\d+) insertions/, 1]
  end

  def deletions
    sections.first[/(\d+) deletions/, 1]
  end

  def details
    commit_messages.map {|section|
      section
    }.join("\n")
  end

  def sha
    commit_messages.first[/^(\S*)\s/, 1]
  end

  def invalid?
    # first line should include a 'file changed'
    !sections.first[/file/]
  end

  private
  def commit_messages
    sections[1..-1]
  end

  def sections
    commit.split("\n")
  end
end
