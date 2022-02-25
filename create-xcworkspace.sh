#!/bin/bash

set -eu

if [ "${1-default}" == "--clean" ]; then
    rm -rf Flickr-App.xcodeproj
    rm -rf Flickr-App.xcworkspace
fi

if ! [ -e Flickr-App/Theme/R/R.generated.swift ]; then
    mkdir -p Flickr-App/Theme/R
    touch Flickr-App/Theme/R/R.generated.swift
fi

./download-tools.sh
./bin/xcodegen/bin/xcodegen generate

if [ "${1-default}" == "--clean" ]; then
    xcodebuild -alltargets clean
fi

bundle install
bundle exec pod install
cp IDETemplateMacros.plist Flickr-App.xcodeproj/xcshareddata/.
