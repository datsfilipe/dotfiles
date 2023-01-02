# How It Looks
![i3 without gaps baby](./assets/showcase.png)

# Install

## Tools to install:

- Peco:
  ```bash
  sudo pacman -S peco
  ```
- Jq:
  ```bash
  paru -S jq
  ```
- Ghq:
  ```bash
  asdf plugin add ghq
  ```
- Commitzen:
  ```bash
  pnpm install -g commitizen cz-conventional-changelog
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
- Github CLI:
  ```bash
  asdf plugin-add github-cli https://github.com/bartlomiejdanek/asdf-github-cli.git
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
- rust-analyzer:
  ```bash
  paru -S rust-analyzer
  ```
- Stylua:
  ```bash
  cargo install stylua
  ```
- Lldb:
  ```bash
  paru -S lldb
  ```

## Docker

```bash
sudo pacman -S docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```
