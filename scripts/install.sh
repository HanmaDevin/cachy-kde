#! /bin/bash
#    ____           __        ____   _____           _       __ 
#    /  _/___  _____/ /_____ _/ / /  / ___/__________(_)___  / /_
#    / // __ \/ ___/ __/ __ `/ / /   \__ \/ ___/ ___/ / __ \/ __/
#  _/ // / / (__  ) /_/ /_/ / / /   ___/ / /__/ /  / / /_/ / /_  
# /___/_/ /_/____/\__/\__,_/_/_/   /____/\___/_/  /_/ .___/\__/  
#                                                  /_/           
clear

download_folder="$HOME/hyprdev/"
cfgPath="$download_folder/.config/"

installPackages() {
    local packages=("cava" "gum" "network-manager-applet" "networkmanager-openvpn" "zip" "man" "libreoffice" "rust-src" "mpv-mpris" "fastfetch" "glow" "ntfs-3g" "tree" "discord" "lazygit" "ufw" "zsh" "unzip" "wget" "yazi" "neovim" "eza" "btop" "gamemode" "steam" "mangohud" "zoxide" "fzf" "bat" "jdk-openjdk" "docker" "ripgrep" "cargo" "fd" "starship" "brightnessctl" "wine" "python-pip" "python-requests" "python-pipx" "openssh" "pam-u2f" "ttf-font-awesome" "ttf-nerd-fonts-symbols" "ttf-jetbrains-mono-nerd" "noto-fonts-emoji" "libfido2" "qt5-wayland" "qt6-wayland" "xdg-desktop-portal-gtk" "xdg-desktop-portal-wlr" "gdb" "pacman-contrib" "libimobiledevice" "usbmuxd" "gvfs-gphoto2" "ifuse" "python-dotenv" "openvpn" "ncdu" "texlive" "lynx" "grim" "slurp" "swappy" "inetutils" "net-tools" "wl-clipboard" "jq" "nodejs" "npm" "nm-connection-editor" "github-cli" "protonmail-bridge" "proton-vpn-gtk-app" "wireguard-tools")
    for pkg in "${packages[@]}"; do
        sudo pacman -S --noconfirm "$pkg"
    done
}

installAurPackages() {
    local packages=("google-chrome" "xwaylandvideobridge" "openvpn-update-systemd-resolved" "lazydocker" "qt-heif-image-plugin" "luajit-tiktoken-bin" "ani-cli")
    for pkg in "${packages[@]}"; do
        yay -S --noconfirm "$pkg"
    done
}

installYay() {
    git clone https://aur.archlinux.org/yay.git "$HOME/yay"
    cd "$HOME/yay"
    makepkg -si
    echo ":: yay has been installed successfully."
}

installDeepCoolDriver() {
  echo "Do you want to install DeepCool CPU-Fan driver?"
  deepcool=$(gum choose "Yes" "No")
  if [[ "$deepcool" == "Yes" ]]; then
    sudo cp "$download_folder/DeepCool/deepcool-digital-linux" "/usr/sbin"
    sudo cp "$download_folder/DeepCool/deepcool-digital.service" "/etc/systemd/system/"
  fi
  sudo systemctl enable deepcool-digital
}

configure_git() {
  echo "Want to configure git?"
  answer=$(gum choose "Yes" "No")
  if [[ "$answer" == "Yes" ]]; then
    username=$(gum input --prompt "> What is your user name?")
    git config --global user.name "$username"
    useremail=$(gum input --prompt "> What is your email?")
    git config --global user.email "$useremail"
    git config --global pull.rebase true
  fi

  echo "Want to create a ssh-key?"
  ssh=$(gum choose "Yes" "No")
  if [[ "$ssh" == "Yes" ]]; then
    ssh-keygen -t ed25519 -C "$useremail"
  fi
}

detect_nvidia() {
  gpu=$(lspci | grep -i '.* vga .* nvidia .*')

  shopt -s nocasematch

  if [[ $gpu == *' nvidia '* ]]; then
    echo "Nvidia GPU is present"
    gum spin --spinner dot --title "Installaling nvidia drivers now..." -- sleep 2
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
  else
    echo "It seems you are not using a Nvidia GPU"
    echo "If you have a Nvidia GPU then download the drivers yourself please :)"
  fi
}

copy_config() {
  gum spin --spinner dot --title "Creating bakups..." -- sleep 2

  if [[ -f "$HOME/.zshrc" ]]; then 
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
  fi

  if [[ -d "$HOME/.config" ]]; then 
    mv "$HOME/.config" "$HOME/.config.bak"
  fi

  if [[ ! -d "$HOME/Pictures/Screenshots/" ]]; then 
    mkdir -p "$HOME/Pictures/Screenshots/"
  fi

  cp "$download_folder/.zshrc" "$HOME/"
  cp -r "$cfgPath" "$HOME/"
  cp -r "$download_folder/Wallpaper/" "$HOME/Pictures/"

  sudo cp -r "$download_folder/Cursor/Bibata-Modern-Ice" "/usr/share/icons"
  sudo cp -r "$download_folder/fonts/" "/usr/share"
  sudo cp "$download_folder/etc/pacman.conf" "/etc/pacman.conf"
  sudo cp "$cfgPath/waybar/weather" "/usr/bin/"
  sudo cp "$download_folder/scripts/pullall" "/usr/bin/"

  sudo cp -r "$download_folder/icons/" "/usr/share/"
 
  echo "Want to install Vencord?"
  vencord=$(gum choose "Yes" "No")

  if [[ "$vencord" == "Yes" ]]; then 
    bash "$download_folder/Vencord/VencordInstaller.sh"
    cp -r "$download_folder/Vencord/themes/" "$HOME/.config/Vencord/"
  fi
}

MAGENTA='\033[0;35m'
NONE='\033[0m'

# Header
echo -e "${MAGENTA}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/

EOF

echo "CachyOS KDE Setup"
echo -e "${NONE}"
while true; do
    read -r -p "Do you want to start the installation now? (Yy/Nn): " yn
    case $yn in
        [Yy]*)
            echo ":: Installation started."
            echo
            break
            ;;
        [Nn]*)
            echo ":: Installation canceled"
            exit
            ;;
        *)
            echo ":: Please answer yes or no."
            ;;
    esac
done

sudo pacman -Syu

# Install required packages
echo ":: Installing required packages..."
installPackages
installYay
installAurPackages

gum spin --spinner dot --title "Starting setup now..." -- sleep 2
copy_config
detect_nvidia
installDeepCoolDriver
configure_git

echo -e "${MAGENTA}"
cat <<"EOF"
    ____  __                        ____       __                __ 
   / __ \/ /__  ____ _________     / __ \___  / /_  ____  ____  / /_
  / /_/ / / _ \/ __ `/ ___/ _ \   / /_/ / _ \/ __ \/ __ \/ __ \/ __/
 / ____/ /  __/ /_/ (__  )  __/  / _, _/  __/ /_/ / /_/ / /_/ / /_  
/_/   /_/\___/\__,_/____/\___/  /_/ |_|\___/_.___/\____/\____/\__/  
EOF
echo "and thank you for choosing my config :)"
echo -e "${NONE}"
