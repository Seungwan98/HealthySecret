#!/bin/sh
#  ci_post_clone.sh
# *.xconfig 파일이 생성될 폴더 경로

brew install cocoapods
pod install

echo "환경변수 참조 Secrets.xcconfig file 생성시작"
# Secrets 경로 지정
cat <<EOF > "/Volumes/workspace/repository/HealthySecret/ConfigRelease.xcconfig"


AlgoliaAppId = $(AlgoliaAppId)
AlgoliaApikey = $(AlgoliaApikey)


EOF



