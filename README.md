<div align="center">

# datsfilipe’s Dotfiles

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/datsfilipe/dotfiles?colorA=A0A0A0&colorB=FFCFA8&style=for-the-badge&logo=github">
<img alt="GitHub issues" src="https://img.shields.io/github/issues/datsfilipe/dotfiles?colorA=A0A0A0&colorB=FFCFA8&style=for-the-badge&logo=github">

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
$ nix-shell -p git # inside the shell...
$ git clone https://github.com/datsfilipe/dotfiles.git --recurse-submodules /mnt/etc/nixos/<name>
$ cd /mnt/etc/nixos/<name>
$ nixos-install --flake .?submodules=1#<host>
```

*Notes:*

- Use `nixos-generate-config` to generate the `/etc/nixos/hardware-configuration.nix` for your machine, then replace the file `hosts/dtsf-machine/hardware-configuration.nix` inside the flake (the repository you just cloned).
- The submodule url configured in this repository uses `ssh` schema, you can change it to use `https` schema, just update the links in `.gitmodules` inside the flake (the repository you just cloned).
