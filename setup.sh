#!/bin/bash
set -eu -o pipefail

ME="/home/$(whoami)"
CFG="${ME}/.config"
DOTDIR="${ME}/pop-dotfiles"
BINDIR="${DOTDIR}/bin"

declare -rA COLORS=(
    [RED]=$'\033[0;31m'
    [GREEN]=$'\033[0;32m'
    [BLUE]=$'\033[0;34m'
    [PURPLE]=$'\033[0;35m'
    [CYAN]=$'\033[0;36m'
    [WHITE]=$'\033[0;37m'
    [YELLOW]=$'\033[0;33m'
    [BOLD]=$'\033[1m'
    [OFF]=$'\033[0m'
)

print_green () {
    echo -e "\n${COLORS[GREEN]}${1}${COLORS[OFF]}\n"
}

update_system () {
    msg="Updating the system..."
    print_green "${msg}"
    sudo apt update && sudo apt upgrade
}

home_link () {
    sudo rm $ME/$2 > /dev/null 2>&1 \
        && ln -s $DOTDIR/$1 $ME/$2 \
        || ln -s $DOTDIR/$1 $ME/$2
}

home_link_cfg () {
    sudo rm -rf $CFG/$1 > /dev/null 2>&1 \
        && ln -s $DOTDIR/$1 $CFG/. \
        || ln -s $DOTDIR/$1 $CFG/.
}

fix_cedilla () {
    msg="Fixing cedilla character on XCompose..."
    print_green "${msg}"
    mkdir -p $DOTDIR/x
    sed -e 's,\xc4\x86,\xc3\x87,g' -e 's,\xc4\x87,\xc3\xa7,g' \
        < /usr/share/X11/locale/en_US.UTF-8/Compose \
        > $DOTDIR/x/XCompose
    home_link "x/XCompose" ".XCompose"
}

install_exa () {
    if [[ -f ${BINDIR}/exa ]]; then
        msg="Exa already installed."
        print_green "${msg}"
    else
        msg="# Downloading Exa (please wait)..."
        print_green "${msg}"
        cd ${BINDIR} \
            && wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip \
            && unzip exa-linux-x86_64-0.9.0.zip \
            && rm exa-linux-x86_64-0.9.0.zip \
            && mv exa-linux-x86_64 exa \
            && cd ..
    fi
}

install_ytdl () {
    msg="Installing / Upgrading youtube-dl..."
    print_green "${msg}"
    sudo -H pip3 install --upgrade youtube-dl
}

install_nvm () {
    msg="Installing nvm..."
    print_green "${msg}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
}

update_system

install_msg="Installing basic packages..."
print_green "${install_msg}"
while read -r p ; do print_green "Installing ${p}..." && sleep 2 && sudo apt install -y $p ; done < <(cat << "EOF"
    build-essential autoconf automake cmake cmake-data pkg-config clang
    python3 ipython3 python3-pip neovim
    tmux most neofetch lzma zip unzip tree
    snapd gnome-tweaks mesa-utils fonts-firacode
    gnome-shell-extension-system-monitor gnome-shell-extension-appindicator
    docker docker-compose
EOF
)

sudo usermod -a -G docker $USER

fix_cedilla
install_exa
install_ytdl
install_nvm

sudo snap install code --classic
sudo snap install skype --classic
sudo snap install slack --classic
snap refresh

home_link "bash/bashrc.sh" ".bashrc"
home_link "bash/inputrc.sh" ".inputrc"
home_link "tmux/tmux.conf" ".tmux.conf"
home_link "tmux/tmux.conf.local" ".tmux.conf.local"

# wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
# sudo add-apt-repository "deb [arch=i386,amd64] https://deb.opera.com/opera-stable/ stable non-free"
# sudo apt update && sudo apt install opera-stable
