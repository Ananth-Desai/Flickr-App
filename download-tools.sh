#!/bin/sh

#  download-tools.sh
#  
#
#  Copyright © 2020 Surya Software Systems Pvt. Ltd.
#  

SWIFT_LINT_VERSION=0.40.3
SWIFT_FORMAT_VERSION=0.46.1
XCODEGEN_VERSION=2.17.0

SWIFT_LINT=./bin/swiftlint
if [ ! -f "$SWIFT_LINT" ]; then
    curl -LJ https://github.com/realm/SwiftLint/releases/download/${SWIFT_LINT_VERSION}/portable_swiftlint.zip \
     -o /tmp/portable_swiftlint.zip

    unzip -o /tmp/portable_swiftlint.zip swiftlint -d ./bin/

    chmod +x ./bin/swiftlint
fi

SWIFT_FORMAT=./bin/swiftformat
if [ ! -f "$SWIFT_FORMAT" ]; then
    curl -LJ https://github.com/nicklockwood/SwiftFormat/archive/${SWIFT_FORMAT_VERSION}.zip \
     -o /tmp/SwiftFormat-${SWIFT_FORMAT_VERSION}.zip

    unzip -o -j /tmp/SwiftFormat-${SWIFT_FORMAT_VERSION}.zip SwiftFormat-${SWIFT_FORMAT_VERSION}/CommandLineTool/swiftformat -d ./bin/

    chmod +x ./bin/swiftformat
fi

XOCDE_GEN=./bin/xcodegen/bin/xcodegen
if [ ! -f "$XOCDE_GEN" ]; then
    curl -LJ https://github.com/yonaskolb/XcodeGen/releases/download/${XCODEGEN_VERSION}/xcodegen.zip \
     -o /tmp/xcodegen.zip

    unzip -o /tmp/xcodegen.zip -d ./bin/
fi
