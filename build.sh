#!/usr/bin/env bash

cd spm
swift package fetch
swift package update
swift package generate-xcodeproj
cd ..
xcodebuild clean && xcodebuild build -project SayIt.xcodeproj  -scheme SayIt-Release CODE_SIGNING_REQUIRED=NO -derivedDataPath ./build