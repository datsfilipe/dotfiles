<div align="center">

# datsfilipe’s Dotfiles

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/datsfilipe/dotfiles?colorA=151515&colorB=ff7a84&style=for-the-badge&logo=github">
<img alt="GitHub issues" src="https://img.shields.io/github/issues/datsfilipe/dotfiles?colorA=151515&colorB=ff7a84&style=for-the-badge&logo=github">

<br/>
<br/>

![Preview](./assets/preview.png)

</div>

## Description

This repository contains personal configuration files for Linux-based systems, specifically tailored for NixOS. This is where I do my rices =D

If you wanna see my past rices, take a look [here](https://myrices.datsfilipe.dev).

## Installation

This flake has *1 host*: ***dtsf-machine***

```bash
$ nix-env -iA nixpkgs.git
$ git clone https://github.com/datsfilipe/dotfiles /mnt/etc/nixos/<name>
$ cd /mnt/etc/nixos/<name>
$ nixos-install --flake .?submodules=1#<host>
```
