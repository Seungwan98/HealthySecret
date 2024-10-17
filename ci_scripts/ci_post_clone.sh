#!/bin/sh
brew install cocoapods
pod install
# Secrets 경로 지정
PATH="/Volumes/workspace/repository"
CONFIGPATH="ConfigRelease.xcconfig"
PODPATH="Pods/Target Support Files/Pods-HealthySecret/Pods-HealthySecret.release.xcconfig"

FULLPODPATH="$PATH/$PODPATH"
FULLCONFIGPATH="$PATH/$CONFIGPATH"


echo "#include $FULLPODPATH" >> "$FULLCONFIGPATH"


echo "AlgoliaAppId = $(AlgoliaAppId)" >> "$FULLCONFIGPATH"

echo "AlgoliaApikey = $(AlgoliaApikey)" >> "$FULLCONFIGPATH"

if [ -f "$FULLPODPATH" ]; then
    echo "$FULLPODPATH exists."
fi
if [ -f "$FULLCONFIGPATH" ]; then
    echo "$FULLCONFIGPATH exists."
fi




