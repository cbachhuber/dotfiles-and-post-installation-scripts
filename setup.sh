#!/bin/bash

set -eu

# TODO add script that executes a command an prompts 'Close me when you're done'
# TODO make programs such as gnome-tweaks, settings etc. silent (no command line output)

prompt_message_and_wait_for_input()
{
    echo "$1"
    sleep 0.5
    read -p "Waiting for you to press [enter]..." DUMMY_VARIABLE
    printf "Continuing execution!\n\n"
    sleep 0.5
}

# Let the user clone this repo to any location
DOTFILES_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIG_FOLDER=""$DOTFILES_PATH"/config"

# OS tweaks
GNOME_TWEAKS_INSTALLED=$(dpkg -l | grep gnome-tweaks | wc -l)  # gnome-tweaks is not part of the default Ubuntu packages: http://releases.ubuntu.com/bionic/ubuntu-18.04.3-desktop-amd64.manifest
if [ $GNOME_TWEAKS_INSTALLED = 0 ]; then
    sudo apt install -y gnome-tweaks gnome-shell-extension-weather gnome-shell-extension-system-monitor gnome-shell-extension-impatience
    printf "Gnome extensions require a logout and login to become visible in gnome settings.
    Please log out and back in, and restart this script."
    return 0
else
    echo "Welcome back! Let's continue with gnome extension settings."
    echo " 1. To use the nice dark mode in your OS, change Appearance->Themes->Applications to 'Adwaita-dark'."
    echo " 2. Also consider changing your cursor appearance"
    echo " 3. Under Top Bar, enable date and week numbers"
    echo " 4. Under 'Extensions', enable and configure openweather and System-monitor. Close me when you're done."
    gnome-tweaks
fi

echo "Add a german, english, or other keyboard layout, if you like. Close me when you're done"
gnome-control-center region
echo "Fix your key repeat delay and rate by clicking 'Typing->Repeat Keys'. Be careful to not set the delay too low, and the rate too high. Experiment with the text editor on the side. Note: the speed slider is inverse! Pushing it leftwards means higher repeat rate. Close the windows if you're done."
gedit & gnome-control-center universal-access
echo "Fix your automatic suspend delays: click on 'Automatic suspend', then choose to your liking. Close when you're done."
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
sudo apt install -y powerline fonts-powerline
prompt_message_and_wait_for_input "Let terminator show more lines: right-click into this text, click 'Preferences->Profile->Scrolling'. Under 'Scrollback', set the number of lines to something more reasonable, e.g. 5000 lines."

# Git configuration
read -p "Enter your git user name: " GIT_NAME
read -p "Enter your git mail address: " GIT_MAIL
git config --global user.name $GIT_NAME
git config --global user.email $GIT_MAIL
git config --global core.pager 'less -F -X'  # use less only if you output does not fit to the screen
git config --global core.excludesFile "$CONFIG_FOLDER"/global_gitignore
echo "[include]
	path = /home/$(whoami)/.dotfiles/config/gitconfig" >> ~/.gitconfig  # $HOME expansion not supported in gitconfig, need absolute path

# Git Editor
while true; do
read -p "Would you like to use vim as git editor? (y/n) " yn
case $yn in
    [Yy]* ) git config --global core.editor 'vim'; break;;  # more handy than nano when closing with 'ZZ' (discard with ':cq')
    [Nn]* ) echo "Not installing"; break;;
    * ) echo "Please answer yes or no.";;
esac
done

# TODO zsh setup (default shell) and configuration
# TODO Check if ~/.zshrc already exists, back up if yes. For all existing config files, use local backup folder
#ln -s "$CONFIG_FOLDER"/zshrc ~/.zshrc

# TODO neovim configuration

# TODO Consider doing the following in a loop
echo "Choose your development language"
echo "Choose your C++ IDE"
