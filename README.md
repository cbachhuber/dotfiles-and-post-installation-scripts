# Ubuntu Post Installation Script and Config Files

Tested for Ubuntu 18.04 LTS. The script and config files in this folder allow you to quickly set up your Ubuntu installation with a reasonable developer configuration.

## Downloading

I suggest cloning this repository to ~/.dotfiles, though any other location will work as well. Just make sure to not move the folder after you started relying on the dotfiles in it.

```
git clone https://github.com/cbachhuber/dotfiles-and-post-installation-scripts.git ~/.dotfiles
```

## Installation

Execute script `setup.sh` in the toplevel folder of this repository

```
.dotfiles/setup.sh
```

You will be asked to enter your sudo password for the apt operations.

### Setup arguments

By default, `setup.sh` will work through all setup steps such a OS tweaks, program installation, git configuration etc. If you only want select a subset of these steps, use the below flags. As soon as a flag is given, the other steps are not implicitly executed, they need to be called explicitly per flag as well.


- Flag `-o` or `--os-tweaks` walks you through OS tweaking steps such as key repeat adjustment and configuration of gnome shell extensions.
- Flag `-p` or `--programs` installs programs such as chromium, vlc, gimp, and dev tools such as python3, terminator, git, and zsh.
- Flag `-g` or `--configure-git` guides you through common git configuration steps such as setting up your git user name and mail, git pager, global excludesFile, and git aliases.
- Flag `-v` or `--configure-vim` guides you through common [neovim](https://github.com/neovim/neovim) configuration steps such as sourcing `~/.zshrc` and installing essential plugins such as [vim-fugitive](https://github.com/tpope/vim-fugitive), [vim-airline](https://github.com/vim-airline/vim-airline), and [vim-nerdtree](https://github.com/scrooloose/nerdtree).
- Flag `-z` or `--configure-zsh` guides you through common zsh and oh-my-zsh configuration steps such as setting zsh as your default shell and installing oh-my-zsh plugins such as [Powerlevel 10k](https://github.com/romkatv/powerlevel10k) and zsh-autosuggestions.
- Flag `-h` or `--help` displays a help menu and exits the script.
