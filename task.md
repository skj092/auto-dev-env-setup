# To Setup

1. Neovim

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# add in zshrc
#export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

2. Neovim custom config setup

```bash
git clone https://github.com/skj092/init.lua.git

git checkout my_config

mv init.lua nvim

mv nvim ~/.config/nvim/

```

2.1 Install Packer for neovim

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
 ```


3. Install Zsh and ohmyzsh

4. clone the dotfiles

```
git clone https://github.com/skj092/.dotfiles.git

# symlink .zhrc file from .dotfiles

ln -s ~/.zshrc .dotfiles/zsh/.zshrc
```

5. Zsh zsh-autosuggestions
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

