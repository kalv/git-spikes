require 'virtus'
require 'byebug'

# parsing commit lines that are from a numstat log output
class NumstatCommit
  include Virtus.model
  attribute :commit, String
  attribute :changes, Array[String], default: []

  IGNORE_FILE_EXTS = 'pdf|jpg|jpeg|gif|png|doc|xls'.freeze

  def insertions
    filtered_changes.map { |change|
      change[/^(\d*)\t/, 1].to_i
    }.sum
  end

  def deletions
    filtered_changes.map { |change|
      change[/^\d*\t(\d*)\t/, 1].to_i
    }.sum
  end

  def delta
    insertions - deletions
  end

  def details
    ([commit] + filtered_changes).join('\n')
  end

  def sha
    commit[/^(\S*)\s/, 1]
  end

  def filtered_changes
    changes.reject {|change|
      change[/(#{IGNORE_FILE_EXTS})$/]
    }
  end

end
