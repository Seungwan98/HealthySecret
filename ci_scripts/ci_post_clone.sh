#!/bin/sh
brew install cocoapods
pod install
# Secrets 경로 지정
PATH="/Volumes/workspace/repository"
CONFIGPATH="ConfigRelease.xcconfig"
PODPATH="Pods/Target Support Files/Pods-HealthySecret/Pods-HealthySecret.release.xcconfig"

FULLPODPATH="$PODPATH"
FULLCONFIGPATH="$PATH/$CONFIGPATH"



echo "#include $FULLPODPATH" >> "$FULLCONFIGPATH"


echo "AlgoliaAppId = $AlgoliaAppId" >> "$FULLCONFIGPATH"

echo "AlgoliaApikey = $AlgoliaApikey" >> "$FULLCONFIGPATH"





