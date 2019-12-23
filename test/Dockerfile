FROM ubuntu:18.04 as base

RUN apt update
RUN apt update
RUN apt install -y git sudo

RUN useradd -ms /bin/bash testuser && echo "testuser:a" | chpasswd && adduser testuser sudo
USER testuser
WORKDIR /home/testuser

RUN git clone https://github.com/cbachhuber/dotfiles-and-post-installation-scripts.git ~/.dotfiles

