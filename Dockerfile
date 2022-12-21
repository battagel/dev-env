FROM debian:latest

ENV TERM=xterm-256color
ENV LANG=UTF-8
ENV TZ=Europe/Dublin
ENV DOCKER_USER dev
ENV TMUX_VERSION 3.3a
ARG COC='coc-css coc-eslint coc-html coc-json coc-sh coc-tsserver coc-prettier coc-lists coc-pyright'

RUN apt-get update

# Setup the user with sudo
RUN apt-get install -y sudo
RUN adduser --disabled-password --gecos '' "$DOCKER_USER"
RUN adduser "$DOCKER_USER" sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER "$DOCKER_USER"
WORKDIR "/home/$DOCKER_USER"
RUN mkdir repos
RUN touch ~/.sudo_as_admin_successful

# Install tools
RUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y libevent-dev
RUN sudo apt-get install -y libncurses-dev
RUN sudo apt-get install -y gettext
RUN sudo apt-get install -y libtool
RUN sudo apt-get install -y libtool-bin
RUN sudo apt-get install -y autoconf
RUN sudo apt-get install -y automake
RUN sudo apt-get install -y doxygen
RUN sudo apt-get install -y ninja-build
RUN sudo apt-get install -y pkg-config
RUN sudo apt-get install -y cmake
RUN sudo apt-get install -y unzip
RUN sudo apt-get install -y tar
RUN sudo apt-get install -y gzip
RUN sudo apt-get install -y tzdata
RUN sudo apt-get install -y curl
RUN sudo apt-get install -y wget
RUN sudo apt-get install -y git
RUN sudo apt-get install -y ripgrep
RUN sudo apt-get install -y fzf
RUN sudo apt-get install -y openssh-client
RUN sudo apt-get install -y man-db
RUN sudo apt-get install -y python3
RUN sudo apt-get install -y python3-pip
RUN sudo apt-get install -y python3-venv
RUN sudo apt-get install -y golang

# Zsh
RUN sudo apt-get install -y zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/z-shell/F-Sy-H.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H
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

# Nvim
RUN cd /tmp && git clone https://github.com/neovim/neovim
RUN cd /tmp/neovim && git checkout stable && make && sudo make install
RUN sudo rm -r /tmp/neovim
# RUN mkdir -p .local/share/nvim/site/spell
# COPY ./spell/ .local/share/nvim/site/spell/
RUN curl -fLo .local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# COPY ./nvim/ .config/nvim/
RUN git clone 'https://github.com/NvChad/NvChad.git' $HOME/.config/nvim
RUN pip3 install pynvim
RUN sudo npm i -g neovim
RUN sudo rm -r /tmp/nvim.dev

# Vim
RUN cd /tmp && git clone https://github.com/vim/vim.git
RUN cd /tmp/vim/src && make && sudo make install
RUN rm -r /tmp/vim
RUN mkdir -p .vim/bundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
COPY ./vim/.vimrc /tmp/.vimrc
RUN cat /tmp/.vimrc > ~/.vimrc && sudo rm /tmp/.vimrc
RUN yes | vim +PluginInstall +qall
RUN npm install --prefix .vim/bundle/coc.nvim

# Tmux
RUN curl -L -o /tmp/tmux.tar.gz "https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz"
RUN cd /tmp && tar xzf "tmux.tar.gz" -C /tmp
RUN cd "/tmp/tmux-$TMUX_VERSION" && ./configure && make && sudo make install
RUN rm -r "/tmp/tmux.tar.gz"
RUN rm -r "/tmp/tmux-$TMUX_VERSION"
COPY ./tmux/.tmux.conf /tmp/.tmux.conf
RUN cat /tmp/.tmux.conf > ~/.tmux.conf && sudo rm /tmp/.tmux.conf
COPY ./tmux/.tmux.conf.local /tmp/.tmux.conf.local
RUN cat /tmp/.tmux.conf.local > ~/.tmux.conf.local && sudo rm /tmp/.tmux.conf.local

# Cleanup
RUN sudo apt-get clean
