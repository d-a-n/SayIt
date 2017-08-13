#!/usr/bin/env bash

cd spm
swift package fetch
swift package update
cd ..
xcodebuild clean && xcodebuild build -project SayIt.xcodeproj  -scheme SayIt-Release CODE_SIGNING_REQUIRED=NO -derivedDataPath ./build