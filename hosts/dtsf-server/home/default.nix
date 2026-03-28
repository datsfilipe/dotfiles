{pkgs, ...}: {
  home.stateVersion = "25.11";

  imports = [
    ./packages.nix
    ../../../modules/programs/git/user.nix
  ];

  programs.fish.functions = {
    vault-open = ''
      if not test -e /dev/mapper/dtsf2-vault
        sudo cryptsetup open /var/lib/vault.img dtsf2-vault
      end
      if not mountpoint -q /home/dtsf-2
        sudo mount /dev/mapper/dtsf2-vault /home/dtsf-2
      end
    '';
    vault-close = ''
      if mountpoint -q /home/dtsf-2
        sudo umount /home/dtsf-2
      end
      if test -e /dev/mapper/dtsf2-vault
        sudo cryptsetup close dtsf2-vault
      end
    '';
  };

  modules.core.shell.fish.user.enable = true;
  modules.programs.git.enable = true;
}
