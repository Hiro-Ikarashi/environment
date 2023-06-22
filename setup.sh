#!/usr/bin/bash

if [ -r /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" = arch ]; then
        down_pkgs=true 
    else
        echo -e "\x1b[31m" "This script was written with arch linux in mind, package installation skipped" "\x1b[m"
        down_pkgs=false
    fi
else
    echo -e "\x1b[31m" "Distribution name cannot be determined, package installation skipped" "\x1b[m"
    down_pkgs=false
fi

while true; do
    echo -e "\x1b[34m" "Testing network connectivity..." "\x1b[m"
    if ! ping -w 5 -c 3 8.8.8.8 &>/dev/null; then
        echo -en "\x1b[31m" "Network connection seems down, retry?[y/n] " "\x1b[m"
        read y
        case "$y" in
            y | Y)
                continue
                ;;
            n | N)
                echo -e "\x1b[31m" "No connection, package installation skipped" "\x1b[m"
                down_pkgs=false
                break
                ;;
            *)
                echo -e "\x1b[31m" "Type either 'y' for yes or 'n' for no" "\x1b[m"
                ;;
        esac
    else
        echo -e "\x1b[32m" "All good" "\x1b[m"
        break
    fi
done

# home directory structure
skel=(.config Documents Downloads Github Music Pictures Projects Scripts Videos)

# packages to install
pkgs=(alacritty alsa-card-profiles alsa-firmware alsa-lib alsa-tools alsa-topology-conf alsa-ucm-conf alsa-utils awesome bat curl exa fd gimp git htop keepassxc libpipewire libqalculate ly mpv mupdf neovim networkmanager nmap nsxiv pcmanfm pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse python python-pip qbittorrent ranger rustup scrot tmux wireshark-qt yay yt-dlp)

# packages to install from the AUR
aur_pkgs=(librewolf-bin)

# addons for librewolf
addons=("Midnight Lizard" "uBlock Origin" "Vimium")

while $down_pkgs; do
    echo -en "\x1b[33m" "Sync repos and install basic packages?[y/n] " "\x1b[m"
    read x
    case "$x" in
        y | Y)
            echo -e "\x1b[34m" "Installing: " "\x1b[m" "${pkgs[@]}"
            sudo pacman -Sy "${pkgs[@]}"
            echo -e "\x1b[34m" "Installing from AUR: " "\x1b[m" "${aur_pkgs[@]}"
            yay -Sy "${aur_pkgs[@]}"
            break
            ;;
        n | N)
            echo -e "\x1b[34m" "OK, skipping package installation" "\x1b[m"
            break
            ;;
        *)
            echo -e "\x1b[31m" "Type either 'y' for yes or 'n' for no" "\x1b[m"
            ;;
    esac
done

echo -e "\x1b[34m" "creating skeleton" "\x1b[m"
mkdir -v "$HOME/${skel[@]}"

echo -e "\x1b[34m" "copying files" "\x1b[m"
for f in dot/*; do
    cp -v "$f" "$HOME/.${f##*/}"
done
cp -vr cfg/* "$HOME/.config"
if [ ! -d /usr/share/fonts/TTF ]; then
    sudo mkdir -vp /usr/share/fonts/TTF
fi
sudo cp -v fonts/* /usr/share/fonts/TTF

echo -e "\x1b[32m" "Done" "\x1b[m"

echo -e "\x1b[33m" "* Additionally, you may want to install these addons for librewolf:" "\x1b[m"
for i in "${addons[@]}"; do
    echo " *   $i"
done
echo -e "\x1b[33m" "* In misc/ you can find a nice colorscheme for Midnight Lizard" "\x1b[m"
