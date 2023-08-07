PKG_MGR := sudo yum install -y
MAKE := sudo make
DEV_REPO := $(PWD)
GIT_CLONE := git clone

NODE_VERSION := 18.0.0
TMUX_VERSION := 3.3a
COC := 'coc-css coc-eslint coc-html coc-json coc-sh coc-tsserver coc-prettier coc-lists coc-pyright'

.DEFAULT_GOAL := setup

.PHONY: splash
confirm_home_dir:
	@echo "                                  _-----_           "
	@echo "                         _________|_____|________   "
	@echo "                        ||__===____________===__||  "
	@echo "                        ||  Matt's Goodie Box!  ||  "
	@echo "                        |:----------------------:|  "
	@echo "                        ||                      ||  "
	@echo "                        ||______________________||  "
	@echo "                        |'----------------------'|  "
	@echo "                        '--'       '--'       '--'  "
	@echo "################ Matt's Developer Environment Setup Tool ################"
	@echo "This script will install the development environment in your home directory."
	@echo "Your current home directory is: $(HOME)"
	@echo "Enure that any proxies have been set up correctly before running"
	@read -p "Are you sure you want to continue? (Y/n) " -r; \
	if [[ $$REPLY =~ ^[Nn] ]]; then \
		exit 1; \
	fi

.PHONY: setup
setup: splash presetup tools bash zsh omz p10k vim nvim clean
	@echo "Installing Dev Environment"

.PHONY: presetup
presetup:
	@echo "Starting Presetup"

.PHONY: tools
tools:
	@echo "Starting Tools installation"
	-$(PKG_MGR) build-essential \
		libevent-dev \
		libncurses-dev \
		gettext \
		libtool \
		libtool-bin \
		autoconf \
		automake \
		doxygen \
		ninja-build \
		pkg-config \
		cmake \
		unzip \
		tar \
		gzip \
		tzdata \
		curl \
		wget \
		git \
		ripgrep \
		fzf \
		openssh-client \
		man-db \
		python3 \
		python3-pip \
		python3-venv \
		golang || { echo "Error: Package installation failed."; exit 1; }

.PHONY: bash
zsh:
	@echo "Starting Bash installation"
	cp $(DEV_REPO)/bash/.profile ~/.profile || { echo "Error: Copying .bashrc failed."; exit 1; }

.PHONY: zsh
zsh:
	@echo "Starting Zsh installation"
	$(PKG_MGR) zsh || { echo "Error: Zsh installation failed."; exit 1; }

.PHONY: omz
omz:
	@echo "Starting Oh-My-Zsh installation"
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || { echo "Error: Oh-My-Zsh installation failed."; exit 1; }
	$(GIT_CLONE) https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions || { echo "Error: Cloning zsh-autosuggestions failed."; exit 1; }
	$(GIT_CLONE) https://github.com/z-shell/F-Sy-H.git $(HOME)/.oh-my-zsh/custom/plugins/F-Sy-H || { echo "Error: Cloning F-Sy-H plugin failed."; exit 1; }
	cp $(DEV_REPO)/zsh/.zshrc ~/.zshrc || { echo "Error: Copying .zshrc failed."; exit 1; }

.PHONY: p10k
p10k:
	@echo "Starting Powerlevel10k installation"
	$(GIT_CLONE) --depth=1 https://github.com/romkatv/powerlevel10k.git $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k || { echo "Error: Cloning Powerlevel10k theme failed."; exit 1; }
	cp $(DEV_REPO)/zsh/.p10k.zsh ~/.p10k.zsh || { echo "Error: Copying .p10k.zsh failed."; exit 1; }

.PHONY: nodejs
nodejs:
	@echo "Starting NodeJS installation"
# 	cd /tmp && curl -L -o node.tar.gz https://nodejs.org/dist/v$(NODE_VERSION/node-v$(NODE_VERSION).tar.gz
# 	tar -xzf node.tar.gz
# 	cd node-v$(NODE_VERSION)
# 	./configure
# 	make
# 	sudo make install
# 	sudo rm -rf /tmp/node-v$(NODE_VERSION)

.PHONY: vim
vim:
	@echo "Starting vim installation"
	cd /tmp && $(GIT_CLONE) https://github.com/vim/vim.git
	cd /tmp/vim/src && $(MAKE) && $(MAKE) install || { echo "Error: Vim installation failed."; exit 1; }
	sudo rm -rf /tmp/vim
	mkdir -p ~/.vim/bundle
	$(GIT_CLONE) https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || { echo "Error: Cloning VundleVim failed."; exit 1; }
	cp $(DEV_REPO)/vim/.vimrc ~/.vimrc
	yes | vim +PluginInstall +qall || { echo "Error: Vim Plugin installation failed."; exit 1; }
# npm install --prefix ~/.vim/bundle/coc.nvim || { echo "Error: Installing coc.nvim failed."; exit 1; }

.PHONY: tmux
tmux:
	@echo "Starting tmux installation"
# Had error when doing this
	curl -L -o /tmp/tmux.tar.gz https://github.com/tmux/tmux/releases/download/$(TMUX_VERSION)/tmux-$(TMUX_VERSION).tar.gz
	cd /tmp && tar xzf tmux.tar.gz -C /tmp
	cd /tmp/tmux-$(TMUX_VERSION) && ./configure && $(MAKE) && sudo $(MAKE) install || { echo "Error: Tmux installation failed."; exit 1; }
	sudo rm -r /tmp/tmux.tar.gz
	sudo rm -r /tmp/tmux-$(TMUX_VERSION)
	cp $(DEV_REPO)/tmux/.tmux.conf /tmp/.tmux.conf
	cp /tmp/.tmux.conf ~/.tmux.conf && sudo rm /tmp/.tmux.conf || { echo "Error: Copying .tmux.conf failed."; exit 1; }
	cp $(DEV_REPO)/tmux/.tmux.conf.local /tmp/.tmux.conf.local
	cp /tmp/.tmux.conf.local ~/.tmux.conf.local && sudo rm /tmp/.tmux.conf.local || { echo "Error: Copying .tmux.conf.local failed."; exit 1; }

.PHONY: nvim
nvim:
	@echo "Skipping neovim installation for now"

.PHONY: clean
clean:
	@echo "Cleaning up"
	source $(HOME).profile
	source $(HOME).zshrc
	source $(HOME).vimrc
	source $(HOME).tmux.conf
	source $(HOME).tmux.conf.local
	sudo yum clean all

.PHONY: remove
remove:
	@echo "Removing Dev Environment"
	@read -p "Are you sure? (Y/n) " -r; \
	if [[ $$REPLY =~ ^[Nn] ]]; then \
		exit 1; \
	fi
	rm -rf $(HOME)/.vim \
		$(HOME)/.vimrc \
		$(HOME)/.tmux.conf \
		$(HOME)/.tmux.conf.local \
		$(HOME)/.p10k.zsh \
		$(HOME)/.oh-my-zsh \
		$(HOME)/.zshrc \
		$(HOME)/.zsh_history \
		$(HOME)/.zsh-update \
		$(HOME)/.zsh-update.lock \
		$(HOME)/.zcompdump \
		$(HOME)/.zsh-autosuggestions \
		$(HOME)/.zsh-syntax-highlighting
	@read -p "Do you want to also delete this repo? (Y/n) " -r; \
	if [[ $$REPLY =~ ^[Yy] ]]; then \
		rm -rf $(DEV_REPO); \
		cd ..; \
	fi
	@echo "Dev Environment removed"
