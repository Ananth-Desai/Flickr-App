#!/bin/bash

set -eu

if [ "${1-default}" == "--clean" ]; then
    rm -rf Flickr.xcodeproj
    rm -rf Flickr.xcworkspace
fi

if ! [ -e Flickr/Theme/R/R.generated.swift ]; then
    mkdir -p Flickr/Theme/R
    touch Flickr/Theme/R/R.generated.swift
fi

./download-tools.sh
./bin/xcodegen/bin/xcodegen generate

if [ "${1-default}" == "--clean" ]; then
    xcodebuild -alltargets clean
fi

bundle install
bundle exec pod install
cp IDETemplateMacros.plist Flickr.xcodeproj/xcshareddata/.
