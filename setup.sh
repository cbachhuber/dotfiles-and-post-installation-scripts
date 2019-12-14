#!/bin/bash

set -eu

# Let the user clone this repo to any location
DOTFILES_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIG_FOLDER=""$DOTFILES_PATH"/config"

# OS tweaks
GNOME_TWEAKS_INSTALLED=$(dpkg -l | grep gnome-tweaks | wc -l)  # gnome-tweaks is not part of the default Ubuntu packages: http://releases.ubuntu.com/bionic/ubuntu-18.04.3-desktop-amd64.manifest
if [ $GNOME_TWEAKS_INSTALLED = 0 ]; then
    sudo apt install -y gnome-tweaks gnome-shell-extension-weather gnome-shell-extension-system-monitor gnome-shell-extension-impatience
    printf "Gnome extensions require a logout and login to become visible in gnome settings.
    Please log out and in, and restart this script."
    return 0
else
    echo "Welcome back! Let's continue with gnome extension settings."
    echo " 1. To use the nice dark mode in your OS, change Appearance->Themes->Applications to 'Adwaita-dark'."
    echo " 2. Also consider changing your cursor appearance"
    echo " 3. Under Top Bar, enable date and week numbers"
    echo " 4. Under 'Extensions', enable and configure openweather and System-monitor"
    gnome-tweaks
fi

echo "Add a german, english, or other keyboard layout, if you like"
gnome-control-center region
echo "Fix your key repeat delay and rate by clicking 'Typing->Repeat Keys'. Be careful to not set the delay too low, and the rate too high. Experiment with a text editor on the side. Note: the speed slider is inverse! Pushing it leftwards means higher repeat rate."
gedit & gnome-control-center universal-access
echo "Fix your automatic suspend delays: click on 'Automatic suspend', then choose to your liking"
gnome-control-center power

# TODO Browser selection
echo "Which browser should we install? (chromium/chrome/no_additional)?"
sudo apt install -y chromium-browser

# Media playback and recording
sudo apt install -y vlc kazam ubuntu-restricted-extras

# Image and graphics tools
echo "Install gimp and inkscape?"
sudo apt install -y gimp inkscape pdftk imagemagick
# TODO fix imagemagick permissions

# Other tools
sudo apt install -y unrar htop iotop

# Essential dev tools
sudo apt install -y neovim zsh git terminator curl python3-dev python3-pip python3-setuptools build-essential cmake libgtest-dev
# TODO configure terminator (~/.config/terminator/config looks like a json file): show more lines than default
sudo apt install -y powerline fonts-powerline

# Git configuration
echo "Enter your git user name:"
read GIT_NAME
echo "Enter your git mail address:"
read GIT_MAIL
git config --global user.name $GIT_NAME
git config --global user.email $GIT_MAIL
# TODO make the following optional
git config --global core.pager 'less -F -X'  # use less only if you output does not fit to the screen
git config --global core.editor 'vim'  # more handy than nano when closing with 'ZZ' (discard with ':cq')
git config --global core.excludesFile "$CONFIG_FOLDER"/global_gitignore
echo "[include]
	path = /home/$(whoami)/.dotfiles/config/gitconfig" >> ~/.gitconfig  # $HOME expansion not supported in gitconfig, need absolute path

# TODO zsh setup (default shell) and configuration
# TODO Check if ~/.zshrc already exists, back up if yes. For all existing config files, use local backup folder
#ln -s "$CONFIG_FOLDER"/zshrc ~/.zshrc

# TODO neovim configuration

# TODO Consider doing the following in a loop
echo "Choose your development language"
echo "Choose your C++ IDE"
