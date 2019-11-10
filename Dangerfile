# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Check and comment on swiftlint only in the range corrected by PR
github.dismiss_out_of_range_messages
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode: true

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500
