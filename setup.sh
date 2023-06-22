#!/usr/bin/bash

# distro check
if [ -r /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" = arch ]; then
        arch=true 
    else
        echo -e "\x1b[31m" "This script was written with arch linux in mind, package installation will be skipped" "\x1b[m"
        arch=false
    fi
else
    echo -e "\x1b[31m" "Distribution name cannot be determined, package installation will be skipped" "\x1b[m"
    arch=false
fi

skel=(.config Documents Downloads Github Music Pictures Projects Scripts Videos)

pkgs=(alacritty awesome bat curl exa fd gimp git htop keepassxc ly mpv mupdf neovim networkmanager nmap nsxiv pcmanfm python python-pip qbittorrent ranger scrot tmux wireshark-qt yt-dlp libqalculate)

# package installation
while $arch; do
    printf "\x1b[33m Sync repos and install basic packages?(~367MB)\x1b[m "
    read x
    case "$x" in
        y | Y)
            echo -e "\x1b[34m" "Installing: " "\x1b[m" "${pkgs[@]}"
            sudo pacman -Sy "${pkgs[@]}"
            break
            ;;
        n | N)
            echo -e "\x1b[34m" "OK, skipping that" "\x1b[m"
            break
            ;;
        *)
            echo -e "\x1b[31m" "Type either 'y' for yes or 'n' for no" "\x1b[m"
            ;;
    esac
done

echo -e "\x1b[34m" "creating skeleton" "\x1b[m"
for dir in ${skel[@]}; do
    mkdir -v "$HOME/$dir"
done

echo -e "\x1b[34m" "copying files" "\x1b[m"
for f in dot/*; do
    cp -v "$f" "$HOME/.$f"
done
cp -vr cfg/* "$HOME/.config"
if [ ! -d /usr/share/fonts/TTF ]; then
    sudo mkdir -vp /usr/share/fonts/TTF
fi
sudo cp -v fonts/* /usr/share/fonts/TTF

echo -e "\x1b[32m" "done" "\x1b[m"
