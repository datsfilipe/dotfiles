<div align="center">

# My dotfiles [I3 Gruvbox Edition]

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/datsfilipe/dotfiles?colorA=1a1a1a&colorB=b8bb26&style=for-the-badge&logo=github">
<img alt="GitHub issues" src="https://img.shields.io/github/issues/datsfilipe/dotfiles?colorA=1a1a1a&colorB=b8bb26&style=for-the-badge&logo=github">

<br/>
<br/>

![Preview](./assets/preview.png)

</div>

## About

This is my personal dotfiles repository. I use it to keep track of my configurations and to make it easier to install them on a new machine.

## Installation

### Requirements

- [Git](https://git-scm.com/)
- [Zsh](https://www.zsh.org/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Alacritty](https://alacritty.org/)
- [Neovim](https://neovim.io/)
- [Tmux](https://github.com/tmux/tmux)
- [Ranger](https://github.com/ranger/ranger)
- [FZF](https://github.com/junegunn/fzf)
- [I3](https://i3wm.org/)
- [Rofi](https://github.com/davatorium/rofi)

### Install

```bash
git clone --bare https://github.com/USERNAME/dotfiles.git $HOME/.dotfiles
# define the alias in the current shell scope (using bash cause is the default)
echo "alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc
dot checkout
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
