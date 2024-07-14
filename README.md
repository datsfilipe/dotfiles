<div align="center">

# datsfilipe’s Dotfiles

<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/datsfilipe/dotfiles?colorA=A0A0A0&colorB=FFCFA8&style=for-the-badge&logo=github">
<img alt="GitHub issues" src="https://img.shields.io/github/issues/datsfilipe/dotfiles?colorA=A0A0A0&colorB=FFCFA8&style=for-the-badge&logo=github">

<br/>
<br/>

![Preview](./assets/preview.png)

</div>

## Description

> Note: The wallpapers I use are here: [https://drive.google.com/drive/folders/walls](https://drive.google.com/drive/folders/1WnRYODfInBXOFI8MJjBgD2rFTosjzVRh?usp=sharing).

This repository contains personal configuration files for Linux-based systems, specifically tailored for NixOS. This is where I do my rices =D

If you wanna see my past rices, take a look [here](https://myrices.datsfilipe.dev) (this website is awful, I know. I'll improve it soon).

## Installation

> An observation: There's probably a better and easier way to do this installation, so if you know a better way, please let me know, I'm not an expert in NixOS.

Some notes before we start:

- `flake` will be used to refer to this project (repository), which is a flake. If you want to know more about flakes and Nix, I recommend [this](https://nixos-and-flakes.thiscute.world/introduction/).
- `<name>` is literally just the name of the folder you can choose to clone the repository as. Ex: `git clone https://github.com/datsfilipe/dotfiles.git /mnt/etc/nixos/<name>`.

### Step-by-step

1. First you need to create your disk partitions and filesystems and mount them. Please refer to [NixOS documentation](https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning) for this.
2. Clone the repository inside the `/mnt/etc/nixos` directory:

```bash
$ nix-shell -p git # inside the shell...
$ git clone https://github.com/datsfilipe/dotfiles.git /mnt/etc/nixos/<name>
```

3. Some tweaks are required. First, you need to update the `.gitmodules` file inside the flake (the repository you just cloned) to point to the correct submodule url. As you don't have my `ssh` keys (thanks god!) you need to update them to `https` links, it's pretty straightforward, so I'm gonna extend on that. After you updated it, do:

```bash
$ git submodule update --init --recursive
```

4. You also need to update the submodule paths insdie `flake.nix` to point to the correct submodule folders. Example:

> `git+file:///home/dtsf/.dotfiles/dotfiles/nvim?shallow=1` -> `git+file:///mnt/etc/nixos/<name>/dotfiles/nvim?shallow=1`

5. You also need to generate your hardware configuration file (if you already created it, you can skip this step). This is done by running:

```bash
$ nixos-generate-config --root /mnt
```

6. You need to delete the `/mnt/etc/nixos/<name>/hosts/dtsf-machine/hardware-configuration.nix` file inside the flake.
7. You need to copy the `/mnt/etc/nixos/hardware-configuration.nix` file inside the flake (copy it to `/mnt/etc/nixos/<name>/hosts/dtsf-machine/hardware-configuration.nix`).
8. Now you can install the system:  

```bash
$ cd /mnt/etc/nixos/<name>
$ nixos-install --flake .?submodules=1#<host>
```

## Star History

<a href="https://star-history.com/#datsfilipe/dotfiles&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=datsfilipe/dotfiles&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=datsfilipe/dotfiles&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=datsfilipe/dotfiles&type=Date" />
  </picture>
</a>
