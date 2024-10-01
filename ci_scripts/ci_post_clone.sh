#!/bin/sh

#  ci_post_clone.sh
#  HealthySecret
#
#  Created by 양승완 on 10/1/24.
#
# Install CocoaPods using Homebrew.
brew install cocoapods

# Install dependencies you manage with CocoaPods.
pod install
