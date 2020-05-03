#!/usr/bin/env bash

set -eu

if [ "$EUID" = 0 ]; then
  echo "Please call me without 'sudo'. The files created in this script otherwise have messed up access rights."
  exit 1
fi

# TODO split me up into separate scripts

OS_TWEAKS=false
PROGRAMS=false
CONFIGURE_GIT=false
CONFIGURE_VIM=false
CONFIGURE_ZSH=false

# Let the user clone this repo to any location
DOTFILES_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIG_FOLDER=""$DOTFILES_PATH"/config"

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -o|--os-tweaks)
        OS_TWEAKS=true
        shift # past argument
        ;;
        -p|--programs)
        PROGRAMS=true
        shift # past argument
        ;;
        -g|--configure-git)
        CONFIGURE_GIT=true
        shift # past argument
        ;;
        -v|--configure-vim)
        CONFIGURE_VIM=true
        shift # past argument
        ;;
        -z|--configure-zsh)
        CONFIGURE_ZSH=true
        shift # past argument
        ;;
        -h|--help)
        printf "Usage: $0 [-o] [-p] [-g] [-z] [-v]\n
This script sets up your OS with a reasonable config and programs. 
Via flags, you have the option to execute a subset of the script steps. 
For more details, see README.md.\n
-o      Walk through OS tweaks setup
-p      Install programs
-g      Git configuration
-v      Neovim configuration
-z      Oh-my-zsh configuration\n"
        exit 0
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "$OS_TWEAKS" = false ] && [ "$PROGRAMS" = false ] && \
   [ "$CONFIGURE_GIT" = false ] && [ "$CONFIGURE_ZSH" = false ] && \
   [ "$CONFIGURE_VIM" = false ]; then
    OS_TWEAKS=true
    PROGRAMS=true
    CONFIGURE_GIT=true
    CONFIGURE_ZSH=true
    CONFIGURE_VIM=true
fi

prompt_message_and_wait_for_input()
{
    echo "$1"
    sleep 0.5
    read -p "Waiting for you to press [enter]..." DUMMY_VARIABLE
    printf "Continuing execution!\n\n"
    sleep 0.5
}

run_command_and_ask_to_close()
{
    echo "Please close the new window(s) when you're done."
    $@ > /dev/null 2>&1
    printf "Windows closed, continuing execution!\n\n"
    sleep 0.5
}

ask_user_to_execute_command()
{
    if [ "$#" = 3 ]; then
        QUESTION=$1
        COMMAND=$2
        NO_MESSAGE=$3
        while true; do
        read -p "$QUESTION [Y/n] " yn
        case $yn in
            [Yy]* ) $COMMAND; break;;
            "" )    $COMMAND; break;;  # Default choice: execute command
            [Nn]* ) echo "$NO_MESSAGE"; break;;
            * ) echo "Please answer yes or no.";;
        esac
        done
    else
        echo "Call me as 'question' 'command to execute' 'Message if no is chosen'"
    fi
}


walk_through_os_tweaks()
{
    echo "Walking through OS tweaks"
    GNOME_TWEAKS_INSTALLED=$(dpkg -l | grep gnome-tweaks | wc -l)  # gnome-tweaks is not part of the default Ubuntu packages: http://releases.ubuntu.com/bionic/ubuntu-18.04.3-desktop-amd64.manifest
    if [ $GNOME_TWEAKS_INSTALLED = 0 ]; then
        sudo apt install -y gnome-tweaks gnome-shell-extension-weather gnome-shell-extension-system-monitor gnome-shell-extension-impatience
        printf "Gnome extensions require a logout and login to become visible in gnome settings.
        Please log out and back in, and restart this script.\n\n"
        return 0
    else
        echo "Welcome back! Let's continue with gnome extension settings."
        echo " 1. To use the nice dark mode in your OS, change Appearance->Themes->Applications to 'Adwaita-dark'."
        echo " 2. Also consider changing your cursor appearance"
        echo " 3. Under Top Bar, enable date and week numbers"
        echo " 4. Under 'Extensions', enable and configure openweather and System-monitor."
        run_command_and_ask_to_close gnome-tweaks
    fi

    echo "Add a german, english, or other keyboard layout, if you like."
    run_command_and_ask_to_close gnome-control-center region
    echo "Fix your key repeat delay and rate by clicking 'Typing->Repeat Keys'. Be careful to not set the delay too low, and the rate too high. Experiment with the text editor on the side. Note: the speed slider is inverse! Pushing it leftwards means higher repeat rate."
    gedit > /dev/null 2>&1 &
    run_command_and_ask_to_close gnome-control-center universal-access
    echo "Fix your automatic suspend delays: click on 'Automatic suspend', then choose to your liking."
    run_command_and_ask_to_close gnome-control-center power
    echo "Consider enabling 'Night Light' (at the bottom of the settings menu). It reduces blue light during dark hours. Comfortable and healthy!"
    run_command_and_ask_to_close gnome-control-center display
}

install_programs()
{
    echo "Installing recommended programs"

    sudo apt update && sudo apt upgrade

    # TODO Browser selection
    ask_user_to_execute_command "Install chromium?" "sudo apt install -y chromium-browser" "Skipping chromium"

    # Media playback and recording
    sudo apt install -y vlc kazam ubuntu-restricted-extras

    # Image and graphics tools
    ask_user_to_execute_command "Install gimp, inkscape, imagemagick?" "sudo apt install -y gimp inkscape imagemagick" "Skipping image processing tools"
    # TODO fix imagemagick permissions

    # Other tools
    sudo apt install -y p7zip-full htop iotop bmon

    # Essential dev tools
    sudo apt install -y neovim zsh git terminator curl python3-dev python3-pip python3-setuptools build-essential cmake libgtest-dev tree
    sudo apt install -y powerline fonts-powerline
    prompt_message_and_wait_for_input "Let terminator show more lines: open terminator, right-click into the empty space, click 'Preferences->Profile->Scrolling'. Under 'Scrollback', set the number of lines to something more reasonable, e.g. 5000 lines."
    ask_user_to_execute_command "Install CLion using snap?" "sudo snap install clion --classic" "Skipping CLion"
    ask_user_to_execute_command "Install PyCharm CE using snap?" "sudo snap install pycharm-community --classic" "Skipping PyCharm CE"
    ask_user_to_execute_command "Install Atom using snap?" "sudo snap install atom --classic" "Skipping Atom"
    ask_user_to_execute_command "Install Visual Studio Code using snap?" "sudo snap install code --classic" "Skipping VS Code"
}

configure_git()
{
    echo "Configuring git"
    sudo apt install -y git
    # Git configuration
    read -p "Enter your git user name (your full name, e.g. 'Max Maier': " GIT_NAME
    read -p "Enter your git mail address: " GIT_MAIL
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_MAIL"
    git config --global core.pager 'less -F -X'  # use less only if you output does not fit to the screen
    git config --global core.excludesFile "$CONFIG_FOLDER"/global_gitignore
    echo "[include]
    	path = /home/$(whoami)/.dotfiles/config/gitconfig" >> ~/.gitconfig  # $HOME expansion not supported in gitconfig, need absolute path

    # Git Editor
    ask_user_to_execute_command "Would you like to use vim as git editor?" "git config --global core.editor 'vim'" "Not using vim as git editor" # more handy than nano when closing with 'ZZ' (discard with ':cq')
}

configure_neovim()
{
    echo "Configuring NeoVim"
    sudo apt install -y neovim curl

    # Linking nvim to ~/.vimrc
    mkdir -p ~/.config/nvim
    touch ~/.config/nvim/init.vim
    echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc" > ~/.config/nvim/init.vim

    # Install vim-plug
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Backing up old vimrc, symlinking to vimrc of this repo
    if [ -f ~/.vimrc ]; then
        echo "Backing up old vimrc to $DOTFILES_PATH/backups/vimrc"
        mkdir -p "$DOTFILES_PATH"/backups
        mv ~/.vimrc "$DOTFILES_PATH"/backups/vimrc
    fi
    ln -s ~/.dotfiles/config/vimrc ~/.vimrc

    nvim -c 'PlugInstall|q|q'  # Using vim-plug to install plugins from vimrc. Then, quit vim
    ask_user_to_execute_command "Remove old vim installation (the more modern neovim will be your new 'vim' alias)?" "sudo apt purge -y vim" "Skipping vim removal"
}

configure_oh_my_zsh()
{
    echo "Configuring Oh-my-zsh"
    sudo apt install -y zsh wget powerline

    # Download and install oh-my-zsh, but do not yet run it (would break this script)
    RUNZSH=no sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ZSH_CUSTOM=/home/$(whoami)/.oh-my-zsh/custom

    # Use oh-my-zsh to install zsh plugins
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # Backing up old zshrc, symlinking to zshrc of this repo
    if [ -f ~/.zshrc ]; then
        echo "Backing up old zshrc to $DOTFILES_PATH/backups/zshrc"
        mkdir -p "$DOTFILES_PATH"/backups
        mv ~/.zshrc "$DOTFILES_PATH"/backups/zshrc
    fi

    ln -s "$CONFIG_FOLDER"/zshrc ~/.zshrc
    echo "Feel free to try out zsh by opening a new terminal (if you made zsh your default shell), or by executing 'zsh' in this terminal. powerlevel10k will ask you a couple of questions on the first zsh start."
}

if [ "$OS_TWEAKS" = true ]; then walk_through_os_tweaks; fi
if [ "$PROGRAMS" = true ]; then install_programs; fi
if [ "$CONFIGURE_GIT" = true ]; then configure_git; fi
if [ "$CONFIGURE_VIM" = true ]; then configure_neovim; fi
if [ "$CONFIGURE_ZSH" = true ]; then configure_oh_my_zsh; fi

exit 0

