#!/bin/bash

function is_wsl {
    if [[ -e /mnt/c/Windows/System32/cmd.exe ]]; then
        return 0
    else
        return 1
    fi
}

function clean {
    sudo apt-get remove -y tmux vim >> $LOGFILE 2>&1
}

function update {
    sudo apt-get update -y &>$LOGFILE
}

function install_docker {
    # Install Docker
    echo "Installing docker"
    sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common >> $LOGFILE 2>&1
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - >> $LOGFILE 2>&1
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" >> $LOGFILE 2>&1
    sudo apt-get update -y >> $LOGFILE 2>&1
    sudo apt-get install -y docker-ce >> $LOGFILE 2>&1

    # Configure Docker
    sed -i -e '/DOCKER_HOST=/d' $ZSHRC
    echo "export DOCKER_HOST=localhost" >> $ZSHRC
}

function install_git {
    # Install Git
    echo "Installing git"
    sudo apt-get install -y git >> $LOGFILE 2>&1
}

function install_zsh {
    # Install Zsh
    echo "Installing zsh"
    sudo apt-get install -y zsh >> $LOGFILE 2>&1
}

function install_omz {
    # Install Oh My Zsh (https://github.com/robbyrussell/oh-my-zsh)
    echo "Installing oh my zsh"
    ZSH=~/.oh-my-zsh
    if [[ ! -e "$ZSH" ]]; then
        git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH >> $LOGFILE 2>&1
    fi

    # Configure Oh My Zsh
    wget -O "$ZSHRC" -q https://raw.githubusercontent.com/zer0beat/env-conf/master/.zshrc >> $LOGFILE 2>&1
    
    ZSH_THEMES=$ZSH/custom/themes/
    mkdir -p $ZSH_THEMES
    git clone https://github.com/bhilburn/powerlevel9k.git $ZSH_THEMES/powerlevel9k >> $LOGFILE 2>&1

    ZSH_PLUGINS=$ZSH/custom/plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting >> $LOGFILE 2>&1
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS/zsh-autosuggestions >> $LOGFILE 2>&1
    git clone https://github.com/zsh-users/zsh-completions $ZSH_PLUGINS/zsh-completions >> $LOGFILE 2>&1
}

function install_tmux {
    # Install tmux (https://github.com/tmux/tmux)
    echo "Installing tmux"
    type tmux >> $LOGFILE 2>&1
    if [[ $? -ne 0 ]]; then
        wget -qO- https://gist.github.com/zer0beat/04824c72055fa47325490ee5f842fa4f/raw | TMUX_VERSION=2.6 bash >> $LOGFILE 2>&1
    fi
    wget -O ~/.tmux.conf -q https://raw.githubusercontent.com/zer0beat/env-conf/master/.tmux.conf >> $LOGFILE 2>&1
    wget -O ~/.tmuxline.conf -q https://raw.githubusercontent.com/zer0beat/env-conf/master/.tmuxline.conf >> $LOGFILE 2>&1
}

function install_vim {
    # Install vim (https://github.com/vim/vim)
    echo "Installing vim"
    type vim >> $LOGFILE 2>&1
    if [[ $? -ne 0 ]]; then
        wget -qO- https://gist.github.com/zer0beat/2f3aa1e81d9bedb0355a46e59ffcea34/raw | VIM_VERSION=8.0.1111 bash >> $LOGFILE 2>&1
    fi

    echo "  Installing NeoBundle"
    NEOBUNDLE=~/.vim/bundle/neobundle.vim
    if [[ ! -e "$NEOBUNDLE" ]]; then
        git clone https://github.com/Shougo/neobundle.vim $NEOBUNDLE >> $LOGFILE 2>&1
    fi
    
    echo " Installing .vimrc"
    wget -O ~/.vimrc -q https://raw.githubusercontent.com/zer0beat/env-conf/master/.vimrc >> $LOGFILE 2>&1

    echo "  Installing vim plugins"
    $NEOBUNDLE/bin/neoinstall >> $LOGFILE 2>&1
}

function install_fzf {
    # Install fzf (https://github.com/junegunn/fzf)
    echo "Installing fzf"
    FZF=~/.fzf
    if [[ ! -e "$FZF" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git $FZF >> $LOGFILE 2>&1
        $FZF/install --all >> $LOGFILE 2>&1
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

function install_powerline_fonts {
    echo "Installing powerline fonts"
    FONTS=$TMP/fonts
    rm -rf $FONTS
    git clone https://github.com/powerline/fonts.git $FONTS >> $LOGFILE 2>&1
    pushd $FONTS >> $LOGFILE 2>&1
    powershell.exe ./install.ps1 "\"DejaVu Sans Mono for Powerline\"" >> $LOGFILE 2>&1
    popd >> $LOGFILE 2>&1
}

function install_awesome_fonts {
    echo "Installing awesome terminal fonts"
    FONTS=$TMP/fonts
    rm -rf $FONTS
    git clone https://github.com/gabrielelana/awesome-terminal-fonts.git $FONTS >> $LOGFILE 2>&1
    pushd $FONTS >> $LOGFILE 2>&1
    powershell.exe ./install.ps1 >> $LOGFILE 2>&1
    popd >> $LOGFILE 2>&1
}

function install_terraform {
    echo "Instaling terraform"
    git clone https://github.com/kamatama41/tfenv.git ~/.tfenv >> $LOGFILE 2>&1
    ln -s ~/.tfenv/bin/* /usr/local/bin
    tfenv install latest >> $LOGFILE 2>&1
}

function install_kubectl {
    echo "Installing kubectl"
    ln -s /mnt/c/Program\ Files/Docker/Docker/resources/bin/kubectl.exe /usr/local/bin/kubectl >> $LOGFILE 2>&1
    wget -O /usr/local/bin/kubectx https://github.com/ahmetb/kubectx/raw/master/kubectx >> $LOGFILE 2>&1
    wget -O /usr/local/bin/kubens https://github.com/ahmetb/kubectx/raw/master/kubens >> $LOGFILE 2>&1
    wget -O ~/.kubectl_aliases https://rawgit.com/ahmetb/kubectl-alias/master/.kubectl_aliases >> $LOGFILE 2>&1
}

function configure_windows_console {
    echo "Configuring Windows console"
    THEME=${THEME:-base16-solarized-light-256}
    wget -O $TMP/console_${THEME}.reg -q https://raw.githubusercontent.com/zer0beat/env-conf/master/wsl/console_${THEME}.reg >> $LOGFILE 2>&1
    wget -O $TMP/Create-CmdShortcut.ps1 -q https://raw.githubusercontent.com/zer0beat/env-conf/master/wsl/Create-CmdShortcut.ps1 >> $LOGFILE 2>&1
    pushd . >> $LOGFILE 2>&1
    cd $TMP
    reg.exe import console_${THEME}.reg >> $LOGFILE 2>&1
    powershell.exe ./Create-CmdShortcut.ps1 >> $LOGFILE 2>&1
    popd >> $LOGFILE 2>&1
}

function configure_variables {
    echo "Configuring variables"
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
}

function set_zsh_as_default_shell {
    echo "Changing shell to zsh"
    sudo sed -i 's/auth       required   pam_shells.so/auth       sufficient   pam_shells.so/' /etc/pam.d/chsh
    chsh -s $(which zsh) >> $LOGFILE 2>&1
    sudo sed -i 's/auth       sufficient   pam_shells.so/auth       required   pam_shells.so/' /etc/pam.d/chsh
}

function install_chocolatey {
    echo "Installing chocolatey"
    powershell.exe -ExecutionPolicy Bypass -Command "Start-Process -Verb runAs -FilePath \"powershell\" -ArgumentList \"iex\",\"((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))\""
}

function install_chocolatey_packages {
    echo "Installing chocolatey packages"
    # --ignore-checksums flag enabled because spotify fails to install, this flag must be deleted in future updates of this script
    powershell.exe -ExecutionPolicy Bypass -Command "Start-Process -Verb runAs -FilePath \"powershell\" -ArgumentList \
    \"choco\", \
    \"install\", \
    \"--yes\",
    \"--ignore-checksums\",
        \"git\",
        \"gitkraken\",
        \"authy\",
        \"spotify\",
        \"googlechrome\",
        \"firefox\",
        \"docker-for-windows --pre\",
        \"7zip\",
        \"caffeine\"
    "
}

LOGFILE=$TMP/env_conf.log
ZSHRC=~/.zshrc

date > $LOGFILE

update
clean
install_awesome_fonts
configure_windows_console
install_git
install_zsh
install_omz
install_fzf
install_docker
install_tmux
install_vim
install_kubectl
install_terraform
configure_variables
set_zsh_as_default_shell

install_chocolatey
install_chocolatey_packages