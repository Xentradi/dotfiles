#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS defaults… (you may be prompted for your password)"
sudo -v

###############################################################################
# General UI/UX
###############################################################################

# Disable press-and-hold for keys in favor of key repeat (better for coding)
defaults write -g ApplePressAndHoldEnabled -bool false

# Faster window resize / UI feel (subtle but noticeable)
defaults write -g NSWindowResizeTime -float 0.001

# Expand save/print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Show scrollbars when scrolling (cleaner UI)
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

###############################################################################
# Finder
###############################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar + path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Search the current folder by default (less “where did my file go?”)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Keep folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Avoid .DS_Store on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

###############################################################################
# Screenshots
###############################################################################

# Create a Screenshots folder
mkdir -p "${HOME}/Pictures/Screenshots"

# Save screenshots to ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Save screenshots as PNG (best default)
defaults write com.apple.screencapture type -string "png"

###############################################################################
# Dock
###############################################################################

# Faster Dock animations
defaults write com.apple.dock autohide-time-modifier -float 0.1
defaults write com.apple.dock autohide-delay -float 0.0

# Automatically hide/show Dock
defaults write com.apple.dock autohide -bool true

# Don’t rearrange Spaces automatically (prevents desktop chaos)
defaults write com.apple.dock mru-spaces -bool false

###############################################################################
# Security / Safety
###############################################################################

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Restart affected services
###############################################################################
echo "Restarting affected services…"
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true

echo "Done. Some changes may require logout/restart."
