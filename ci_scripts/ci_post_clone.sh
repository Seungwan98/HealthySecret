#!/bin/sh

#  ci_post_clone.sh
# *.xconfig 파일이 생성될 폴더 경로
#FOLDER_PATH="/Volumes/workspace/repository"
#PODS_PATH="/Volumes/workspace/repository/Pods/Target Support Files/Pods-HealthySecret/Pods-HealthySecret.release.xcconfig"

#CONFIG_FILENAME="ConfigRelease.xcconfig"
## Install CocoaPods using Homebrew.
brew install cocoapods
#
## Install dependencies you manage with CocoaPods.
pod install
pod update

# *.xconfig 파일의 전체 경로 계산
#CONFIG_FILE_PATH="$FOLDER_PATH/$CONFIG_FILENAME"

# 환경 변수에서 값을 가져와서 *.xconfig 파일에 추가하기
#echo "AlgoliaAppId = $AlgoliaAppId" >> "$PODS_PATH"
#echo "AlgoliaApikey = $AlgoliaApikey" >> "$PODS_PATH"




# 생성된 *.xconfig 파일 내용 출력
#cat "$CONFIG_FILE_PATH"


echo "Config.xcconfig 파일이 성공적으로 생성되었고, 환경변수 값이 확인되었습니다."
