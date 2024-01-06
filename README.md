# auto-dev-env-setup

```
#!/bin/bash

# 1. Build Essential
sudo apt-get update
sudo apt-get install build-essential -y
sudo apt-get install sudo -y
sudo apt-get install ninja-build gettext cmake unzip curl -y

# 2. Install Git
sudo apt-get install git -y

# 3. Install Neovim
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
git checkout stable
sudo make install

# 4. Neovim Configuration
cd $HOME
git clone https://github.com/skj092/init.lua.git
# Install Packer for Neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# 5. Install Neovim packages (you can add your package installations here)

# Optionally, you can add package installations using Lua in your init.lua file.
# For example:
# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Development environment setup completed."
```
