#!/bin/bash

osascript -e 'tell application "System Events" to tell every desktop to set picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Stone.png"'
defaults write com.apple.screencapture target clipboard
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide -bool true
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.sharingd AirDrop -int 0
defaults write com.apple.iphonesimulator NSUserKeyEquivalents -dict "Rotate Left" "^h" "Rotate Right" "^l"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 0
killall Dock
killall SystemUIServer
