require 'virtus'

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
    sections[1, -1].join("\n")
  end

  def invalid?
    # first line should include a 'file changed'
    !sections.first[/file/]
  end

  private

  def sections
    commit.split("\n")
  end
end
