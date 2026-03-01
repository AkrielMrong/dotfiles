#!/bin/bash

echo "1. Installing system packages..."
sudo apt-get update
sudo apt-get install -y zsh git curl wget neofetch

echo "2. Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "3. Installing Powerlevel10k and Plugins..."
# These are required if your .zshrc references them
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "4. Applying your personal dotfiles..."
# GitHub runs this script from inside the cloned repo, so we copy them to the home directory
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh

echo "5. Configuring automatic Zsh launch for SSH..."
if ! grep -q "exec zsh" ~/.bashrc; then
    echo 'if [ -t 1 ] && [ -x "$(command -v zsh)" ]; then exec zsh; fi' >> ~/.bashrc
fi

echo "Success! Your workspace is ready."
