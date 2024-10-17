#!/bin/sh

brew install cocoapods
pod install

echo "환경변수 참조 ConfigRelease.xcconfig file 생성시작"
# Secrets 경로 지정
PATH="/Volumes/workspace/repository/HealthySecret/ConfigRelease.xcconfig"
PODPATH="/Pods/Target Support Files/Pods-HealthySecret/Pods-HealthySecret.release.xcconfig"
FULLPODPATH="$PATH/$PODPATH"


echo "#include "$FULLPODPATH"" >> "$PATH"


echo "AlgoliaAppId = $(AlgoliaAppId)" >> "$PATH"

echo "AlgoliaApikey = $(AlgoliaApikey)" >> "$PATH"






