#!/usr/bin/env bash

set -e

echo "=== Развертывание системы ==="

# Копирование конфигов
mkdir -p "$HOME/.config/hypr"
mkdir -p "$HOME/.config/kitty"
cp hypr/* "$HOME/.config/hypr/"
cp kitty/* "$HOME/.config/kitty/"

# Установка тем Rofi
TMP_ROFI=$(mktemp -d)
git clone --depth 1 https://github.com/adi1090x/rofi.git "$TMP_ROFI/rofi"
cd "$TMP_ROFI/rofi"
chmod +x setup.sh
./setup.sh
cd - > /dev/null
rm -rf "$TMP_ROFI"

# Алиасы
if [ -f "bashrc_extra" ]; then
    if ! grep -q "source $HOME/Nixos_config/bashrc_extra" "$HOME/.bashrc"; then
        echo -e "\n# Nixos_config custom aliases\nsource $HOME/Nixos_config/bashrc_extra" >> "$HOME/.bashrc"
    fi
fi

# Копирование NixOS конфига и пересборка
sudo cp nixos/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch

echo "=== Готово ==="
