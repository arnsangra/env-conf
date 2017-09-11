#!/bin/bash

BASHRC=~/.bashrc
ZSHRC=~/.zshrc

sudo apt-get update -y

# Install Git
sudo apt-get install -y git

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
sed -i -e '/DOCKER_HOST=/d' $BASHRC
echo "export DOCKER_HOST=localhost" >> $BASHRC

# Install Zsh
sudo apt-get install -y zsh

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
wget -P $ZSH_THEMES -qO- https://raw.githubusercontent.com/zer0beat/env-conf/master/omz-themes/agnoster-short.zsh-theme
wget -P $ZSH_THEMES -qO- https://raw.githubusercontent.com/zer0beat/env-conf/master/omz-themes/robbyrussell-for-wsl.zsh-theme

sed -i -e 's ZSH_THEME=\"\(.*\)\" ZSH_THEME=\"robbyrussell-for-wsl\" ' $ZSHRC
sed -i -e 's/^plugins=\(.*\)/plugins=(git docker mvn ubuntu tmuxinator git-flow pip python terraform)/' $ZSHRC

# Install tmux (https://github.com/tmux/tmux)
type tmux
if [[ $? -ne 0 ]]; then
    wget -qO- https://gist.github.com/zer0beat/04824c72055fa47325490ee5f842fa4f/raw | TMUX_VERSION=2.5 bash
fi

# Install fzf (https://github.com/junegunn/fzf)
FZF=~/.fzf
if [[ ! -e "$FZF" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $FZF
    $FZF/install --all
fi

# Configure variables

# Fix WSL Windows colors
sed -i -e '/LS_COLORS=/d' $BASHRC
echo "export LS_COLORS='ow=01;36;40'" >> $BASHRC

sed -i -e '/TERM=/d' $BASHRC
echo "export TERM=xterm-256color" >> $BASHRC

# Configure tmuxinator
#sed -i -e '/SHELL=/d' $BASHRC
#echo "export SHELL=$(which zsh)" >> $BASHRC
#sed -i -e '/EDITOR=/d' $BASHRC
#echo "export EDITOR=$(which vim)" >> $BASHRC

# Configure folders
sed -i -e '/PROJECTS=/d' $BASHRC
echo "export PROJECTS=$PROJECTS" >> $BASHRC

sed -i -e '/TMP=/d' $BASHRC
echo "export TMP=$TMP" >> $BASHRC

sed -i -e '/WINDOWS_HOME=/d' $BASHRC
echo "export WINDOWS_HOME=$(cmd.exe \/C 'echo %USERPROFILE%' 2> /dev/null | tr -d '[:space:]')" >> $BASHRC

sed -i -e '/alias p=/d' $BASHRC
echo 'alias p="cd $PROJECTS"' >> $BASHRC

sed -i -e '/alias t=/d' $BASHRC
echo 'alias t="cd $TMP"' >> $BASHRC

sed -i -e '/alias h=/d' $BASHRC
echo 'alias h="cd $WINDOWS_HOME"' >> $BASHRC

# Start zsh by default
# sed -i -e '/exec \"zsh\"/d' $BASHRC
# echo "exec \"zsh\"" >> $BASHRC
# echo "prompt_context(){}" >> $BASHRC