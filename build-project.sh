#!/bin/bash

set -eu

# Download binaries
./download-tools.sh

# Formatting
./bin/swiftformat .

# Linting
./bin/swiftlint lint

# Install dependencies
bundle install
  
# Xcode build and test
xcodebuild test -sdk iphonesimulator -destination 'platform=iOS Simulator,OS=14.0,name=iPhone 11 Pro Max' -workspace Flickr.xcworkspace -scheme Flickr | XCPRETTY_JSON_FILE_OUTPUT=xcodebuild.json xcpretty -f `xcpretty-json-formatter`

# Run Danger
bundle exec danger dry_run
