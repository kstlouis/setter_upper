#!/bin/bash

######################## Creating new ssh keys  ###################################

function ssh_keygen() {

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

######################## SCRIPT STARTS  ###################################

# Check for the --no-ssh argument
if [[ "$*" == *"--no-ssh"* ]]; then
    echo "Skipping ssh-related commands."
else
    ssh_keygen
fi

######################## Install Homebrew  ###################################

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install MonitorControl via Homebrew
brew install MonitorControl

#Install iTerm2 via Homebrew
brew install --cask iterm2

######################## iTerm2 modifications ################################

#Tweak these as needed later. 
#This might be helpful: https://iterm2.com/documentation-dynamic-profiles.html

#Install Source Code Pro font
#brew tap homebrew/cask-fonts && brew install --cask font-source-code-pro

######################## Install ohmyzsh ####################################

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#TODO: add plugins
# - sublimetext plugin

######################## Add apps to the Dock ####################################

#TODO

# defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>\
# /Applications/APP NAME GOES HERE.app\
# </string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"; killall Dock

######################## Add Wallpapers repo ####################################

git clone https://github.com/kstlouis/Wallpapers.git ~/



