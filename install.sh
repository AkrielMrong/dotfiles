#!/bin/bash

# 1. Find exactly where this script is located so file copying never fails
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "1. Installing system packages..."
# The "|| true" ensures that a minor repo key error (like Yarn) doesn't stop the whole script
sudo apt-get update || true
sudo apt-get install -y zsh git curl wget neofetch

echo "2. Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "3. Installing Powerlevel10k and Plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "4. Applying your personal dotfiles..."
# Safely copy using the exact directory path we found at the top of the script
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    cp "$DOTFILES_DIR/.zshrc" ~/.zshrc
    echo "Copied .zshrc successfully."
fi

if [ -f "$DOTFILES_DIR/.p10k.zsh" ]; then
    cp "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh
    echo "Copied .p10k.zsh successfully."
fi

echo "5. Configuring automatic Zsh launch for Termux SSH..."
if ! grep -q "exec zsh" ~/.bashrc; then
    echo 'if [ -t 1 ] && [ -x "$(command -v zsh)" ]; then exec zsh; fi' >> ~/.bashrc
fi

echo "Success! Your workspace is fully automated and ready."
