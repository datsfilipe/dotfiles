<div align="center">

# My dotfiles [Evangelion Edition]

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/datsfilipe/dotfiles?colorA=1a1a1a&colorB=FF7A84&style=for-the-badge&logo=github">
<img alt="GitHub issues" src="https://img.shields.io/github/issues/datsfilipe/dotfiles?colorA=1a1a1a&colorB=FF7A84&style=for-the-badge&logo=github">

<br/>
<br/>

![Preview](./assets/preview.png)

</div>

# Dependencies:

**Note: Replace `paru` with your preferred AUR helper if needed.**

<details>
<summary><b>System Packages</b></summary>

```bash
paru -S xdg-utils xdg-user-dirs zip unzip xclip openssh xorg-xrandr xorg-xsetroot xorg udisks2 udiskie pipewire flatpak
```
</details>

<details>
<summary><b>Fonts</b></summary>

```bash
paru -S ttf-dejavu otf-font-awesome noto-fonts-emoji noto-fonts-cjk
```
</details>

<details>
<summary><b>Window Manager and Utilities</b></summary>

```bash
paru -S bspwm sxhkd polybar dunst rofi ranger xwinwrap feh picom dragon-drop cronie
```
</details>

<details>
<summary><b>Terminal</b></summary>

```bash
paru -S alacritty tmux fish neovim fd ripgrep bat exa fzf btop git asdf-vm wget curl

# asdf version manager plugins
asdf plugin add ghq && asdf install ghq latest && asdf global ghq latest
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && asdf list all nodejs && asdf install nodejs lts && asdf global nodejs lts
asdf plugin-add pnpm && asdf install pnpm latest && asdf global pnpm latest
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git && asdf install rust latest && asdf global rust latest # I will learn rust one day...
asdf plugin-add github-cli https://github.com/bartlomiejdanek/asdf-github-cli.git && asdf install github-cli latest && asdf global github-cli latest

# pomodoro cli tool (it has rain sound :3)
git clone https://github.com/gabrielzschmitz/Tomato.C.git
cd Tomato.C
sudo make install

# fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install franciscolourenco/done # notification when a long running command finishes
fisher install jorgebucaran/hydro # prompt

# fetch
wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sh setup.sh

# dev packages
pnpm i -g all-the-package-names stylelint @commitlint/cli @commitlint/config-conventional rustywind eslint_d
paru -S proselint editorconfig-checker
cargo install stylua

# cronie
sudo systemctl enable cronie.service
sudo systemctl start cronie.service
anacron -t $HOME/.local/etc/anacrontab -S $HOME/.local/var/spool
```

</details>

<details>
<summary><b>Apps</b></summary>

```bash
paru -S mpv peek flameshot screenkey obs-studio zathura zathura-pdf-poppler chromium qbittorrent lxappearance
```
</details>

<details>
<summary><b>Neovim</b></summary>

<br/>

*Colorscheme: [Github](https://github.com/projekt0n/github-nvim-theme)*

```bash
git clone https://github.com/datsfilipe/datsnvim $HOME/.config/nvim
nvim # should open Lazy window and install plugins
```
</details>

#### Colors

Now I'm using [Min Theme for VS Code](https://github.com/misolori/min-theme-vscode) **colors**!

#### GTK Theme

I'm using [Yaru Colors red](https://www.pling.com/s/XFCE/p/1299514).

#### Cursor Theme

I'm using [MacOS Big Sur](https://www.pling.com/p/1408466).

#### Special Thanks

- *Me.*
- *Myself.*
