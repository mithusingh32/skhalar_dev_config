#!/bin/zsh 

repo_dir=${0:a:h}

echo "Install zsh or fish before continuing."

echo "Install nvim"
sudo mkdir -p /opt/neovim/
sudo curl -Lo /opt/neovim/nvim.appimage https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
sudo chmod +x /opt/neovim/*
sudo ln -sf /opt/neovim/nvim.appimage /usr/local/bin/nvim

echo "installing pre-reqs"
sudo apt install -y fd-find luarocks ripgrep curl
sudo luarocks install jsregexp
curl -L git.io/antigen > $HOME/.oh-my-zsh/custom/plugins/antigen.zsh
chmod +x  $HOME/.oh-my-zsh/custom/plugins/antigen.zsh

echo "Please install required fonts"
font_dir="$HOME/.local/share/fonts"
mkdir -p $font_dir
curl -Lo $font_dir https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -Lo $font_dir https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -Lo $font_dir https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -Lo $font_dir https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$font_dir"
fi 

echo "Setting up LazyVim"
ln -sf $repo_dir/nvim $HOME/.config/nvim


echo "Setting up zsh"
if [  -f $HOME/.zshrc ]; then
	mv -v $HOME/.zshrc $HOME/.zshrc.bak
fi

if [ -f $HOME/.p10k.zsh ]; then 
	mv -v $HOME/.p10k.zsh $HOME/.p10k.zsh.bak
fi

ln -sf $repo_dir/oh-my-zsh/zshrc  $HOME/.zshrc
ln -sf  $repo_dir/oh-my-zsh/p10k.zsh $HOME/.p10k.zsh

echo "Installing lazy git"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

echo "Installing Jetbrain Toolbox"
wget -cO jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
sudo mkdir -p /opt/jetbrains-toolbox
sudo tar -xzf jetbrains-toolbox.tar.gz -C /opt/jetbrains-toolbox

echo "Installing fisher"
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
