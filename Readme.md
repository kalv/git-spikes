# Git log analyzer

A tool to help extract logs with information to order and reference for SRED claim work.

Will output a CSV which can then be ordered to see which large peices of work was committed or merged into a repo.

## Usage:

`bundle install`

`ruby process.rb git-repo-url.git repo-name`

Will output a csv of the breakdown of commits for the time frame defined in `process.rb`.

To change the timeframes edit the `FROM` and `TO` from `process.rb`.

## Excluded files

When viewing the log and reviewing the insertions, it will show the insertions and deletions of binary files, this can create confusion when reviewing the insertions and deletions on Github as they exclude the binary changes.

This tool ignores those, but in case a certain file extension is not being ignored, you can edit `IGNORE_FILE_EXTS` in `NumstatCommit.rb`
