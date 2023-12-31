#!/bin/bash

# THIS SCRIPT NEEDS TO BE RUN AS ROOT.

######################## FUNCTIONS ###################################
function generate_ssh_key() {
  # Prompt for the desired file name to save the ssh key
  read -p "Enter the file name for the ssh key (default: id_ed25519): " filename
  filename=${filename:-id_ed25519}

  # Prompt for the email address to use in the ssh key comment
  read -p "Enter the email address for the ssh key comment: " email

  # Generate the ssh key
  ssh-keygen -t ed25519 -C "$email" -f "$filename"

  # Check if key generation was successful
  if [ $? -eq 0 ]; then
    echo "ssh key generation successful."
    echo "Your public key has been saved in ${filename}.pub"
    echo "Your private key has been saved in ${filename}"
  else
    echo "ssh key generation failed."
  fi

  # Add the new ssh key to the ssh agent
  echo -e "\nHost github.com\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
  ssh-add ~/.ssh/id_ed25519
}

function install_homebrew(){
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

function install_neovim() {
  brew install neovim
}
# TODO: plugins / dotfile

function install_monitor_control(){
  brew install MonitorControl
}

function install_iterm() {
  brew install --cask iterm2
}
# This might be helpful: https://iterm2.com/documentation-dynamic-profiles.html
# iTerm TODO: need to figure out perferences for iTerm

function setup_github(){
  brew install gh
  git config --global user.name "Kellan St.Louis"
  brew tap microsoft/git
  brew install --cask git-credential-manager-core
}

function install_custom_fonts(){
  # Source Code Pro
  brew tap homebrew/cask-fonts && brew install --cask font-source-code-pro
}

function install_sublime_text() {
  brew install --cask sublime-text

  #Add to PATH so "subl" can be used in terminal
  echo 'export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"' >> ~/.zprofile

  # Change font to source code pro:
  echo "{\n    \"font_face\": \"Source Code Pro\",\n    \"font_size\": \"14\",\n}" >> ~/Library/Application\ Support/Sublime\ Text/Packages/User/Preferences.sublime-settings
}

function install_oh_my_zsh() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
# ZSH TODO: add plugins
# - sublimetext plugin
# - autofilll, previous history

function clear_apps_from_dock {
    defaults delete com.apple.dock persistent-apps
    killall Dock
}

function add_dock_item() {
    printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>', "$1"
}

function setup_dock() {
    #Turn on autohide
    defaults write com.apple.dock "autohide" -bool "true"
    #Make dock movements immediate
    defaults write com.apple.dock autohide-time-modifier -float 0
    #Move dock to left side of display
    defaults write com.apple.dock orientation left
    # Disable recent applications showing in the Dock --- this isn't working????
    defaults write com.apple.dock show-recents -bool "false"
    #Remove all existing items - this might not be needed since we're using -array instead of -array-add
    clear_apps_from_dock

    defaults write com.apple.dock persistent-apps -array \
    "$(add_dock_item /System/Applications/Launchpad.app)" \
    "$(add_dock_item /Applications/Google\ Chrome.app)" \
    "$(add_dock_item /System/Applications/Mail.app)" \
    "$(add_dock_item /System/Applications/Notes.app)" \
    "$(add_dock_item /Applications/Slack.app)" \
    "$(add_dock_item /Applications/Sublime\ Text.app)" \
    "$(add_dock_item /System/Applications/System\ Settings.app)" \
    "$(add_dock_item /Applications/Numbers.app)" \
    "$(add_dock_item /Applications/Parcel.app)" \
    "$(add_dock_item /Applications/Jobber\ Tools.app)" \
    "$(add_dock_item /Applications/iTerm.app)" \
    "$(add_dock_item /Applications/zoom.us.app)"
    killall Dock
}

function install_slack_cli() {
  curl -fsSL https://downloads.slack-edge.com/slack-cli/install.sh | bash
}

function set_wallpaper() {
  git clone https://github.com/kstlouis/Wallpapers.git ~/
  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/kellan/Wallpapers/desert_sphere.jpg"'
}
#TODO - set pattern, have wallpaper change on timed interval if possible 

function install_neovim() {
  brew install neovim
}

function set_lock_screen() {
  defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Kellan - 780-868-0310"
}

function set_preferred_view_style() {
  defaults write com.apple.Finder FXPreferredViewStyle clmv
  find / -name .DS_Store -delete; killall Finder
}

function install_teams() {
  brew install --cask microsoft-teams
}

# function set_screensaver() {
#   defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName "Album Artwork" path /System/Library/Screen\ Savers/Album\ Artwork.saver/ type 0
# }
# not currently working WIP


# MORE TODOs
# add the permanent sudo-touchID file (sonoma beta only)
# allow USB to connect automatically when unlocked
#    - defaults write com.apple.applicationaccess allowUSBRestrictedMode -bool false
#    - doesn't work, but maybe a start?
# custom screensaver!
# column view by default in Finder!!!!
#    - Airdrop to everyone
#    - disable follow-up suggestions in Mail
# install teams

######################## APPLICATION START ###################################

echo "Running .."

# Check for the --with-ssh argument  <--- this is fine, but should build something better
if [[ "$*" == *"--with-ssh"* ]]; then
    generate_ssh_key
else
    echo "Skipping ssh keygen."
fi

install_homebrew
install_neovim
install_monitor_control
install_custom_fonts
install_iterm
install_sublime_text
install_oh_my_zsh
install_neovim
install_teams
setup_github
setup_dock
set_wallpaper
set_lock_screen
set_preferred_view_style
#install_slack_cli
