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

print_cyan () {
    echo -e "\n${COLORS[CYAN]}${1}${COLORS[OFF]}\n"
}

wait_key () {
    echo -e "\n${COLORS[YELLOW]}"
    read -n 1 -s -r -p "${1}"
    echo -e "${COLORS[OFF]}\n"
}

update_system () {
    msg="Updating the system..."
    print_cyan "${msg}"
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
    print_cyan "${msg}"
    mkdir -p $DOTDIR/x
    sed -e 's,\xc4\x86,\xc3\x87,g' -e 's,\xc4\x87,\xc3\xa7,g' \
        < /usr/share/X11/locale/en_US.UTF-8/Compose \
        > $DOTDIR/x/XCompose
    home_link "x/XCompose" ".XCompose"
    sudo cp /usr/lib/x86_64-linux-gnu/gtk-3.0/3.0.0/immodules.cache /usr/lib/x86_64-linux-gnu/gtk-3.0/3.0.0/immodules.cache.bckp
    sudo sed -i 's,"az:ca:co:fr:gv:oc:pt:sq:tr:wa","az:ca:co:fr:gv:oc:pt:sq:tr:wa:en",g' /usr/lib/x86_64-linux-gnu/gtk-3.0/3.0.0/immodules.cache
    sudo cp /usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules.cache /usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules.cache.bckp
    sudo sed -i 's,"az:ca:co:fr:gv:oc:pt:sq:tr:wa","az:ca:co:fr:gv:oc:pt:sq:tr:wa:en",g' /usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules.cache
    sudo cp $DOTDIR/etc/environment /etc/environment
}

install_exa () {
    if [[ -f ${BINDIR}/exa ]]; then
        msg="Exa already installed."
        print_cyan "${msg}"
    else
        msg="# Downloading Exa (please wait)..."
        print_cyan "${msg}"
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
    print_cyan "${msg}"
    sudo -H pip3 install --upgrade youtube-dl
}

install_nvm () {
    msg="Installing nvm..."
    print_cyan "${msg}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
}

install_yarn_package () {
    if $(yarn --version > /dev/null 2>&1); then
        msg="Yarn already installed."
        print_green "${msg}"
    else
        msg="Installing Yarn package..."
        print_cyan "${msg}"
        sudo apt update && sudo apt install yarn
    fi
}

install_yarn () {
    msg="Installing Yarn..."
    print_cyan "${msg}"
    if $(APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key list | grep "Yarn Packaging" > /dev/null 2>&1); then
        msg="Yarn GPG key already added to system."
        print_green "${msg}"
    else
        msg="Adding Yarn GPG key to system..."
        print_cyan "${msg}"
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    fi
    if [[ -f /etc/apt/sources.list.d/yarn.list ]]; then
        msg="Yarn sources list already added to system."
        print_green "${msg}"
        install_yarn_package
    else
        msg="Adding yarn.list to sources.list.d..."
        print_cyan "${msg}"
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        install_yarn_package
    fi
}

install_awscli () {
    if $(aws --version > /dev/null 2>&1); then
        msg="AWS CLI already installed."
        print_green "${msg}"
    else
        msg="Installing AWS CLI..."
        print_cyan "${msg}"
        pip3 install awscli --upgrade --user
    fi
}

update_system

install_msg="Installing basic packages..."
print_cyan "${install_msg}"
while read -r p ; do print_cyan "Installing ${p}..." && sleep 2 && sudo apt install -y $p ; done < <(cat << "EOF"
    build-essential autoconf automake cmake cmake-data pkg-config clang
    mlocate python3 ipython3 python3-pip python-is-python3 neovim
    libsdl2-dev libsdl2-ttf-dev libfontconfig-dev qt5-default
    gnome-tweaks mesa-utils fonts-firacode imagemagick ffmpeg vlc
    gnome-shell-extension-system-monitor gnome-shell-extension-appindicator
    tmux most neofetch lzma zip unzip tree obs-studio obs-plugins
    docker docker-compose zsh zsh-doc network-manager-openvpn
    dialog xmlstarlet
EOF
)

sudo usermod -a -G docker $USER

fix_cedilla
install_exa
install_ytdl
install_nvm
install_yarn
install_awscli

# wait_key "Press any key to perform snap installs and updates..."
# sudo snap install code --classic
# sudo snap install skype --classic
# sudo snap install slack --classic
# snap refresh

home_link "bash/bashrc.sh" ".bashrc"
home_link "bash/inputrc.sh" ".inputrc"
home_link "tmux/tmux.conf" ".tmux.conf"
home_link "tmux/tmux.conf.local" ".tmux.conf.local"
# home_link_cfg "nvim"

cat $DOTDIR/x/gterminal.conf | dconf load /org/gnome/terminal/

# wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
# sudo add-apt-repository "deb [arch=i386,amd64] https://deb.opera.com/opera-stable/ stable non-free"
# sudo apt update && sudo apt install opera-stable
