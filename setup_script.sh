#!/bin/bash

######################## SCRIPT STARTS  ###################################


# # Check for the --no-ssh argument  <--- this is fine, but should build something better
# if [[ "$*" == *"--no-ssh"* ]]; then
#     echo "Skipping ssh-related commands."
# else
#     generate_ssh_key
# fi

# generate_ssh_key <-- commented out for now during testing
install_homebrew
install_monitor_control
install_custom_fonts
install_iterm
install_sublime_text
install_oh_my_zsh
setup_github
setup_dock


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
  # Install Source Code Pro font
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
    "$(add_dock_item /Applications/Numbers.app)" \
    "$(add_dock_item /Applications/Parcel.app)" \
    "$(add_dock_item /Applications/iTerm.app)" \
    "$(add_dock_item /Applications/zoom.us.app)"
    killall Dock
}

######################## Add Wallpapers repo ####################################
git clone https://github.com/kstlouis/Wallpapers.git ~/
# still need to figure out how to set using script




