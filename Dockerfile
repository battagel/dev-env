FROM debian:latest


# This tutorial does not include how to optimize the image size, therefore
# we won't be placing various commands on a single line.
RUN apt-get update

# Install sudo command...
RUN apt-get install -y sudo

# Feel free to change this to whatever your want
ENV DOCKER_USER dev

# Start by creating our passwordless user.
RUN adduser --disabled-password --gecos '' "$DOCKER_USER"

# Give root priviledges
RUN adduser "$DOCKER_USER" sudo

# Give passwordless sudo. This is only acceptable as it is a private
# development environment not exposed to the outside world. Do NOT do this on
# your host machine or otherwise.
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the user to be our newly created user by default.
USER "$DOCKER_USER"

# This will determine where we will start when we enter the container.
WORKDIR "/home/$DOCKER_USER"

# The sudo message is annoying, so skip it
RUN touch ~/.sudo_as_admin_successful

# We will need this to build c/c++ dependencies. This is common enough
# in all my various projects that I include it in my base image; there are
# often transitive dependencies in Python/NodeJs/Rust projects which require
# c/c++ compilation.
RUN sudo apt-get install -y build-essential

# The Ubuntu image does not include curl. I prefer it, but it isn't necessary.
# Note that if you decide to not install this you will need to use wget instead
# for some of the installation commands in this tutorial.
RUN sudo apt-get install -y curl

# We will need git so we can clone repositories
RUN sudo apt-get install -y git

# SSH is not bundled by default. I always use ssh to push to Github.
RUN sudo apt-get install -y openssh-client

# The manuals are always handy for development.
RUN sudo apt-get install -y man-db

### The start of the dev environment settings ###

# Install zsh terminal
RUN sudo apt-get install -y zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install oh my zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/z-shell/F-Sy-H.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H
# Move config files
COPY ./zsh/.zshrc /tmp/.zshrc
RUN cat /tmp/.zshrc > ~/.zshrc && sudo rm /tmp/.zshrc
COPY ./zsh/matthewbattagel.zsh-theme /tmp/matthewbattagel.zsh-theme 
RUN cat /tmp/matthewbattagel.zsh-theme > ~/.oh-my-zsh/themes/matthewbattagel.zsh-theme && sudo rm /tmp/matthewbattagel.zsh-theme
ENTRYPOINT [ "/bin/zsh" ]

# Powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
COPY ./zsh/.p10k.zsh /tmp/.p10k.zsh
RUN cat /tmp/.p10k.zsh > ~/.p10k.zsh && sudo rm /tmp/.p10k.zsh


# NodeJS
ARG DEBIAN_FRONTEND=noninteractive
RUN curl -sL https://deb.nodesource.com/setup_14.x -o setup_14.sh
RUN sudo sh ./setup_14.sh
RUN rm ./setup_14.sh
RUN sudo apt update
RUN sudo apt-get install -y nodejs

# Vim
RUN sudo apt-get install -y vim
RUN mkdir -p "$HOME/.vim/bundle"
RUN git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
COPY ./vim/.vimrc /tmp/.vimrc
RUN cat /tmp/.vimrc > ~/.vimrc && sudo rm /tmp/.vimrc
RUN yes | vim +PluginInstall +qall
# Setup Coc
RUN npm install --prefix .vim/bundle/coc.nvim
RUN echo skip

# Tmux
RUN sudo apt-get install -y tmux

# Python3
RUN sudo apt-get install -y python3

# GoLang
RUN sudo apt-get install -y golang

# Cleanup
RUN sudo apt-get clean

