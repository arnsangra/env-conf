#!/bin/bash

function is_wsl {
    if [[ -e /mnt/c/Windows/System32/cmd.exe ]]; then
        return 0
    else
        return 1
    fi
}

function clean {
    sudo apt-get remove -y tmux vim &>$LOGFILE
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
    echo "Installing git"
    sudo apt-get install -y git &>$LOGFILE
}

function install_zsh {
    # Install Zsh
    echo "Installing zsh"
    sudo apt-get install -y zsh &>$LOGFILE
}

function install_omz {
    # Install Oh My Zsh (https://github.com/robbyrussell/oh-my-zsh)
    echo "Installing Oh my zsh"
    ZSH=~/.oh-my-zsh
    if [[ ! -e "$ZSH" ]]; then
        git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH &>$LOGFILE
        cp $ZSH/templates/zshrc.zsh-template ~/.zshrc
        sed "/^export ZSH=/ c\\
        export ZSH=$ZSH
        " ~/.zshrc > ~/.zshrc-omztemp
        mv -f ~/.zshrc-omztemp ~/.zshrc
    fi

    # Configure Oh My Zsh
    ZSH_THEMES=$ZSH/custom/themes/
    mkdir -p $ZSH_THEMES
    wget -O $ZSH_THEMES/agnoster-short.zsh-theme -q https://raw.githubusercontent.com/zer0beat/env-conf/master/omz-themes/agnoster-short.zsh-theme &>$LOGFILE
    wget -O $ZSH_THEMES/robbyrussell-for-wsl.zsh-theme -q https://raw.githubusercontent.com/zer0beat/env-conf/master/omz-themes/robbyrussell-for-wsl.zsh-theme &>$LOGFILE

    sed -i -e 's ZSH_THEME=\"\(.*\)\" ZSH_THEME=\"robbyrussell-for-wsl\" ' $ZSHRC
    sed -i -e 's/^plugins=\(.*\)/plugins=(git docker mvn ubuntu tmuxinator git-flow pip python terraform)/' $ZSHRC
}

function install_tmux {
    # Install tmux (https://github.com/tmux/tmux)
    echo "Installing tmux"
    type tmux &>$LOGFILE
    if [[ $? -ne 0 ]]; then
        wget -qO- https://gist.github.com/zer0beat/04824c72055fa47325490ee5f842fa4f/raw | TMUX_VERSION=2.5 bash &>$LOGFILE
    fi
}

function install_vim {
    # Install vim (https://github.com/vim/vim)
    echo "Installing vim"
    type vim &>$LOGFILE
    if [[ $? -ne 0 ]]; then
        wget -qO- https://gist.github.com/zer0beat/2f3aa1e81d9bedb0355a46e59ffcea34/raw | VIM_VERSION=8.0.1111 bash &>$LOGFILE
    fi
}

function install_fzf {
    # Install fzf (https://github.com/junegunn/fzf)
    echo "Installing fzf"
    FZF=~/.fzf
    if [[ ! -e "$FZF" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git $FZF &>$LOGFILE
        $FZF/install --all &>$LOGFILE
    fi
}

function install_whalebox {
    # Install whalebox (https://github.com/zer0beat/whalebox)
    WHALEBOX=~/.whalebox
    if [[ ! -e "$WHALEBOX" ]]; then
        mkdir -p $WHALEBOX
        wget -O $WHALEBOX/whalebox.zsh -q https://raw.githubusercontent.com/zer0beat/whalebox/master/whalebox.zsh 
    fi
    sed -i -e "/whalebox.zsh/d" $ZSHRC
    echo "source $WHALEBOX/whalebox.zsh" >> $ZSHRC
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

function install_powerline_fonts {
    FONTS=$TMP/fonts
    rm -rf $FONTS
    git clone https://github.com/powerline/fonts.git $FONTS
    pushd .
    cd $FONTS
    powershell.exe ./install.ps1 "\"DejaVu Sans Mono for Powerline\""
    popd
}

function configure_windows_console {
    THEME=${THEME:-base16-google-dark-256}
    wget -O $TMP/console_${THEME}.reg -q https://raw.githubusercontent.com/zer0beat/env-conf/master/console_${THEME}.reg
    pushd .
    cd $TMP
    reg.exe import console_${THEME}.reg
    popd
}

LOGFILE=$TMP/env_conf.log
ZSHRC=~/.zshrc

sudo apt-get update -y &>$LOGFILE
clean
if is_wsl; then
    echo "You are on Windows Subsystem Linux!"
    install_powerline_fonts
    configure_windows_console
fi
install_git
install_zsh
install_omz
install_fzf
install_docker
install_tmux
install_vim
#install_whalebox

# Configure variables
clean_this_exports_from "LS_COLORS SHELL EDITOR PROJECTS TMP WINDOWS_HOME" $ZSHRC
clean_this_alias_from "p t h" $ZSHRC

# Fix WSL Windows colors
echo "export LS_COLORS='ow=01;36;40'" >> $ZSHRC

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

sudo sed -i 's/auth       required   pam_shells.so/auth       sufficient   pam_shells.so/' /etc/pam.d/chsh
chsh -s $(which zsh)
sudo sed -i 's/auth       sufficient   pam_shells.so/auth       required   pam_shells.so/' /etc/pam.d/chsh