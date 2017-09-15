#!/bin/bash

function clean {
    sudo apt-get remove -y tmux vim
}

function install_docker {
    # Install Docker
    sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce

    # Configure Docker
    sed -i -e '/DOCKER_HOST=/d' $ZSHRC
    echo "export DOCKER_HOST=localhost" >> $ZSHRC
}

function install_git {
    # Install Git
    sudo apt-get install -y git
}

function install_zsh {
    # Install Zsh
    sudo apt-get install -y zsh

    # Start zsh by default
    sed -i -e '/exec \"zsh\"/d' $BASHRC
    echo "exec \"zsh\"" >> $BASHRC
}

function install_omz {
    # Install Oh My Zsh (https://github.com/robbyrussell/oh-my-zsh)
    ZSH=~/.oh-my-zsh
    if [[ ! -e "$ZSH" ]]; then
        git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH
        cp $ZSH/templates/zshrc.zsh-template ~/.zshrc
        sed "/^export ZSH=/ c\\
        export ZSH=$ZSH
        " ~/.zshrc > ~/.zshrc-omztemp
        mv -f ~/.zshrc-omztemp ~/.zshrc
    fi

    # Configure Oh My Zsh
    ZSH_THEMES=$ZSH/custom/themes/
    mkdir -p $ZSH_THEMES
    wget -P $ZSH_THEMES -q https://raw.githubusercontent.com/zer0beat/env-conf/master/omz-themes/agnoster-short.zsh-theme
    wget -P $ZSH_THEMES -q https://raw.githubusercontent.com/zer0beat/env-conf/master/omz-themes/robbyrussell-for-wsl.zsh-theme

    sed -i -e 's ZSH_THEME=\"\(.*\)\" ZSH_THEME=\"robbyrussell-for-wsl\" ' $ZSHRC
    sed -i -e 's/^plugins=\(.*\)/plugins=(git docker mvn ubuntu tmuxinator git-flow pip python terraform)/' $ZSHRC
}

function install_tmux {
    # Install tmux (https://github.com/tmux/tmux)
    type tmux
    if [[ $? -ne 0 ]]; then
        wget -qO- https://gist.github.com/zer0beat/04824c72055fa47325490ee5f842fa4f/raw | TMUX_VERSION=2.5 bash
    fi
}

function install_vim {
    # Install tmux (https://github.com/vim/vim)
    type vim
    if [[ $? -ne 0 ]]; then
        wget -qO- https://gist.github.com/zer0beat/2f3aa1e81d9bedb0355a46e59ffcea34/raw | VIM_VERSION=8.0.1111 bash
    fi
}

function install_fzf {
    # Install fzf (https://github.com/junegunn/fzf)
    FZF=~/.fzf
    if [[ ! -e "$FZF" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git $FZF
        $FZF/install --all
    fi
}

function clean_this_elements_from {
    local types=$1
    local elements=$2
    local file=$3
    for e in $elements; do
        sed -i -e "/$types $e=/d" $file
    done
}

function clean_this_exports_from {
    clean_this_elements_from "export" "$1" "$2"
}

function clean_this_alias_from {
    clean_this_elements_from "alias" "$1" "$2"
}

BASHRC=~/.bashrc
ZSHRC=~/.zshrc

sudo apt-get update -y
clean
install_git
install_zsh
install_omz
install_fzf
install_docker
install_tmux
install_vim

# Configure variables
clean_this_exports_from "LS_COLORS TERM SHELL EDITOR PROJECTS TMP WINDOWS_HOME" $ZSHRC
clean_this_alias_from "p t h" $ZSHRC

# Fix WSL Windows colors
echo "export LS_COLORS='ow=01;36;40'" >> $ZSHRC
echo "export TERM=xterm-256color" >> $ZSHRC

# Configure tmuxinator
echo "export SHELL=$(which zsh)" >> $ZSHRC
echo "export EDITOR=$(which vim)" >> $ZSHRC

# Configure folders
echo "export PROJECTS=$PROJECTS" >> $ZSHRC
echo "export TMP=$TMP" >> $ZSHRC
echo "export WINDOWS_HOME='/mnt/c/Users/$(cmd.exe \/C 'echo %USERNAME%' 2> /dev/null | tr -d '[:space:]')'" >> $ZSHRC

echo 'alias p="cd $PROJECTS"' >> $ZSHRC
echo 'alias t="cd $TMP"' >> $ZSHRC
echo 'alias h="cd $WINDOWS_HOME"' >> $ZSHRC

# echo "prompt_context(){}" >> $ZSHRC