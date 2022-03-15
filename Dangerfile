# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

# Show reasons for build failure if any
xcode_summary.ignored_files = 'Pods/**'
xcode_summary.inline_mode = true
# Add additional reports using the following format if iOS build targets are added in CI
xcode_summary.report 'xcodebuild.json'


# Run SwiftFormat and fail if there are any violations.
swiftformat.binary_path = "./bin/swiftformat"
swiftformat.additional_args = "--config .swiftformat"
swiftformat.check_format(fail_on_error: true)

# Run SwiftLint and fail if there are any violations
swiftlint.binary_path = './bin/swiftlint'
swiftlint.lint_files inline_mode: true

# https://github.com/PGSSoft/danger-ios_logs
# Ensure there are no `NSLog` or `print` calls.
ios_logs.check :fail

# Check content of diff for common warnings
# Warnings currently checked for:
#   - Disabling swiftlint checks
#   - Leaving TODOs in
def check_diff_for_warnings
    files_of_interest = git.modified_files + git.added_files
    files_of_interest.each do |f|
        next if !f.end_with? ".swift"
        diff = git.diff_for_file(f)
        changed_lines = GitDiffParser::Patch.new(diff.patch).changed_lines
        changed_lines.each do |line|
            if line.content.include? "swiftlint:disable:next"
                warn("You are disabling a swiftlint check for the next line. Are you sure this is necessary? Location: #{f}:#{line.number}", file: f, line: line.number)
            elsif line.content.include? "swiftlint:disable"
                warn("You are disabling a swiftlint check for the rest of this file. Are you **absolutely sure** this is necessary? Location: #{f}:#{line.number}", file: f, line: line.number)
            end
            if line.content.upcase.include? "TODO"
                warn("Your PR has a TODO - are you sure you want to leave this for later? Location: #{f}:#{line.number}", file: f, line: line.number)
            end
        end
    end
end

check_diff_for_warnings
