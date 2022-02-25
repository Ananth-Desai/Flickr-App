# Flickr-App

Flickr-App App
This repository customizes the location of git hooks to enable tracking them in git (by default git hooks are stored in`.git/hooks` which is not tracked, so we store them in `.githooks`).

Run `git config core.hooksPath .githooks` from the root of the repository right after you clone the repository to make this work. Note this step is **mandatory**.

## Tools

### Bundler

This project uses Ruby tools for building and CI. To ensure we’re all using the same versions of these tools, we use Bundler.

To install Bundler run `gem install bundler`.

To install ruby dependencies (AKA gems) run `bundle install` from the root of the repo.

To execute Ruby commands, prefix them with `bundle exec`. For example, to run danger, run `bundle exec danger dry_run`.

To update to newer versions of gems, run `bundle update`.

### CocoaPods

This project builds with [CocoaPods](https://cocoapods.org).

To start, run `bundle exec pod install`.

To update to newer versions of dependencies, run `bundle exec pod repo update && bundle exec pod update`. 

To update only a specific dependency, run `bundle exec pod update [dependency_name]`

### SwiftLint

This project uses [SwiftLint](https://github.com/realm/SwiftLint) to ensure that uniform coding conventions are followed.

If the tool `./bin/swiftlint` doesn't exist, run `./download-tools.sh` script to download the tool.

To update the swiftlint binary to the latest version of SwiftLint, modify the `./download-tools.sh` script to point to the correct version number.

### SwiftFormat

This project uses [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to enforce a uniform code format.

To format code run `./bin/swiftformat .` from the root of the repo. This will result in all Swift code in the directory being formatted for you in compliance with our guidelines. If the tool `./bin/swiftformat` doesn't exist, run `./download-tools.sh` script to download the tool.

The project is set up to fail on CI if code is not formatted in compliance with SwiftFormat.

There is also a git pre-commit hook to fail the commit if it fails SwiftFormat.
To update the swiftformat binary to the latest version of SwiftFormat, modify the `./download-tools.sh` script to point to the correct version number.

### Danger

This project uses [Danger](https://github.com/danger/danger) to help catch errors. To run it locally, run `bundle exec danger dry_run` from the root of the repo.

### XcodeGen

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate the Xcode project. To generate the project run `./create-xcworkspace.sh` in terminal from the root of the repo.

If the tool `./bin/xcodegen/bin/xcodegen` doesn't exist, run `./download-tools.sh` script to download the tool.

To update the xcodegen binary to the latest version of XcodeGen, modify the `./download-tools.sh` script to point to the correct version number.
