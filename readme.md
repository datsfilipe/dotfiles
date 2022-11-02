# How It Looks
![i3 without gaps baby](./assets/showcase.png)

# Install

## Tools to install:

- Peco:
  ```bash
  sudo pacman -S peco
  ```
- Ghq:
  ```bash
  asdf plugin add ghq
  ```
- Hub:
  ```bash
  sudo pacman -S hub
  ```
- Git Lfs:
  _download the binary in here: https://github.com/git-lfs/git-lfs/releases_
  ```bash
  # extract, go to the folder and run:
  sudo ./install.sh
  ```
- Commitzen:
  ```bash
  pnpm install -g commitzen cz-conventional-changelog
  ```
- Rustywind:
  ```bash
  pnpm i -g rustywind
  ```

## Asdf Plugins

- Node:
  ```bash
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  ```
- Golang:
  ```bash
  asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
  ```
- Pnpm:
  ```bash
  asdf plugin-add pnpm
  ```
- Rust:
  ```bash
  asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
  ```

## Neovim Needed

- Cspell:
  ```bash
  pnpm install -g cspell@latest
  ```
- Typescript:
  ```bash
  pnpm install -g typescript typescript-language-server
  ```
- Eslint_d:
  ```bash
  pnpm install -g eslint_d
  ```
