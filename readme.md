# How It Looks
![Rice showcase](./assets/showcase.png)

*Note: Hatsune Miku!*

# Setup tools:

```bash
paru -S peco lldb asdf-vm docker alacritty tmux fish i3-wm bspwm polybar dunst sxhkd rofi ranger dragon-drop xclip openssh neovim ttf-font-awesome xwinwrap mdt # and others ...

# Install tomato from:
# https://github.com/gabrielzschmitz/Tomato.C.git

# asdf version manager
asdf plugin add ghq && asdf install ghq latest
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && asdf install nodejs lts
asdf plugin-add pnpm && asdf install pnpm latest
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git && asdf install rust latest
asdf plugin-add github-cli https://github.com/bartlomiejdanek/asdf-github-cli.git && asdf install github-cli latest

# pnpm packages
pnpm install -g commitizen cz-conventional-changelog rustywind cspell@latest eslint_d

# cargo packages
cargo install stylua

# docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```
