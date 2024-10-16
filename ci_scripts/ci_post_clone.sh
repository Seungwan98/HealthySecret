#!/bin/sh

brew install cocoapods
pod install

echo "환경변수 참조 ConfigRelease.xcconfig file 생성시작"
# Secrets 경로 지정
cat <<EOF > "/Volumes/workspace/repository/HealthySecret/ConfigRelease.xcconfig"

echo '#include "Pods/Target Support Files/Pods-HealthySecret/Pods-HealthySecret.release.xcconfig"' >> "/Volumes/workspace/repository/HealthySecret/ConfigRelease.xcconfig"



AlgoliaAppId = $(AlgoliaAppId)
AlgoliaApikey = $(AlgoliaApikey)


EOF



