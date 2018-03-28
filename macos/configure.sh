#!/bin/bash

function install_homebrew {
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null >> $LOGFILE 2>&1
}

function install_wget {
    echo "Installing wget"
    brew install wget >> $LOGFILE 2>&1
}

function install_tmux {
    echo "Installing tmux"
    brew install tmux >> $LOGFILE 2>&1
    wget -O ~/.tmux.conf -q https://raw.githubusercontent.com/zer0beat/env-conf/master/.tmux.conf >> $LOGFILE 2>&1
    wget -O ~/.tmuxline.conf -q https://raw.githubusercontent.com/zer0beat/env-conf/master/.tmuxline.conf >> $LOGFILE 2>&1
}

function install_git {
    echo "Installing git"
    brew install git >> $LOGFILE 2>&1
    brew install git-flow >> $LOGFILE 2>&1
}

function install_vim {
    echo "Installing vim"
    brew install vim >> $LOGFILE 2>&1

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

function install_mc {
    echo "Installing mc"
    brew install mc >> $LOGFILE 2>&1
}

function install_kubectl {
    echo "Installing kubectl"
    brew install kubectl >> $LOGFILE 2>&1
    brew install kubectx >> $LOGFILE 2>&1
    wget -O ~/.kubectl_aliases https://rawgit.com/ahmetb/kubectl-alias/master/.kubectl_aliases >> $LOGFILE 2>&1
}

function install_terraform {
    echo "Installing terraform"
    brew install tfenv >> $LOGFILE 2>&1
    tfenv install latest >> $LOGFILE 2>&1
}

function install_iterm2 {
    echo "Installing iterm2"
    brew cask install iterm2 >> $LOGFILE 2>&1
    mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles/
    wget -O ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm2-default.json -q https://raw.githubusercontent.com/zer0beat/env-conf/master/macos/iterm2-default.json >> $LOGFILE 2>&1
}

function install_caffeine {
    echo "Installing caffeine"
    brew cask install caffeine >> $LOGFILE 2>&1
}

function install_chrome {
    echo "Installing chrome"
    brew cask install google-chrome >> $LOGFILE 2>&1
}

function install_firefox {
    echo "Installing firefox"
    brew cask install firefox >> $LOGFILE 2>&1
}

function install_gitkraken {
    echo "Installing gitkraken"
    brew cask install gitkraken >> $LOGFILE 2>&1
}

function install_spotify {
    echo "Installing spotify"
    brew cask install spotify >> $LOGFILE 2>&1
}

function install_vscode {
    echo "Installing visual studio code"
    brew cask install visual-studio-code >> $LOGFILE 2>&1
    code --install-extension PeterJausovec.vscode-docker >> $LOGFILE 2>&1
    code --install-extension eamodio.gitlens >> $LOGFILE 2>&1
    code --install-extension mauve.terraform >> $LOGFILE 2>&1
    code --install-extension mikestead.dotenv >> $LOGFILE 2>&1
    code --install-extension ms-python.python >> $LOGFILE 2>&1
    code --install-extension redhat.java >> $LOGFILE 2>&1
    code --install-extension vscjava.vscode-maven >> $LOGFILE 2>&1   
}

function install_authy {
    echo "Installing authy"
    brew cask install authy >> $LOGFILE 2>&1
}

function install_caffeine {
    echo "Installing caffeine"
    brew cask install caffeine >> $LOGFILE 2>&1
}

function install_docker {
    echo "Installing docker edge"
    brew cask install caskroom/versions/docker-edge >> $LOGFILE 2>&1
}

function install_tunnelblick {
    echo "Installing tunnelblick"
    brew cask install tunnelblick >> $LOGFILE 2>&1
}

function install_unarchiver {
    echo "Installing unarchiver"
    brew cask install the-unarchiver >> $LOGFILE 2>&1
}

function install_bettertouchtool {
    echo "Installing better touch tool"
    brew cask install bettertouchtool >> $LOGFILE 2>&1
}

function install_remote_desktop {
    echo "Installing remote desktop beta"
    brew cask install microsoft-remote-desktop-beta >> $LOGFILE 2>&1
}

function install_awesome_fonts {
    echo "Installing awesome terminal fonts"
    brew tap caskroom/fonts >> $LOGFILE 2>&1
    brew cask install font-awesome-terminal-fonts >> $LOGFILE 2>&1
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
    brew install zsh-syntax-highlighting
    echo '# zsh syntax highlighting' >> $ZSHRC
    echo 'source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> $ZSHRC
    # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting >> $LOGFILE 2>&1

    brew install zsh-autosuggestions
    echo '# zsh autosuggestions' >> $ZSHRC
    echo 'source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> $ZSHRC
    #git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS/zsh-autosuggestions >> $LOGFILE 2>&1
    git clone https://github.com/zsh-users/zsh-completions $ZSH_PLUGINS/zsh-completions >> $LOGFILE 2>&1
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

function configure_variables {
    echo "Configuring variables"
    # Configure variables
    clean_this_exports_from "SHELL EDITOR PROJECTS TMP" $ZSHRC
    clean_this_alias_from "p t" $ZSHRC

    # Configure tmuxinator
    echo "export SHELL=$(which zsh)" >> $ZSHRC
    echo "export EDITOR=$(which vim)" >> $ZSHRC

    # Configure folders
    echo "export PROJECTS=$PROJECTS" >> $ZSHRC
    echo "export TMP=$TMP" >> $ZSHRC

    echo 'alias p="cd $PROJECTS"' >> $ZSHRC
    echo 'alias t="cd $TMP"' >> $ZSHRC

    # iterm2 truecolor support
    echo "export COLORTERM=truecolor" >> $ZSHRC    
}

function set_zsh_as_default_shell {
    chsh -s $(which zsh) >> $LOGFILE 2>&1
}

PROJECTS_FOLDER='Repositories'
LOGFILE=$TMP/env_conf.log
ZSHRC=~/.zshrc

date > $LOGFILE

if [[ -d $HOME/$PROJECTS_FOLDER ]]; then
    mkdir -p ${PROJECTS_FOLDER}
fi

# Configure console
install_homebrew
install_wget
install_tmux
install_git
install_vim
install_fzf
install_omz
install_kubectl
install_terraform
configure_variables
set_zsh_as_default_shell

# Install desktop apps
install_awesome_fonts
install_iterm2
install_caffeine
install_chrome
install_firefox
install_spotify
install_gitkraken
install_vscode
install_authy
install_caffeine
install_docker
install_tunnelblick
install_unarchiver
install_bettertouchtool
install_remote_desktop
