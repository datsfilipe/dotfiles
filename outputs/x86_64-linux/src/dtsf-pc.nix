{
  lib,
  myvars,
  mylib,
  system,
  inputs,
  genSpecialArgs,
  ...
} @ args: let
  name = "dtsf-pc";
  monitorsConfig = {
    enable = true;
    enableNvidiaSupport = true;
    monitors = [
      {
        name = "DP-2";
        focus = true;
        resolution = "1920x1080";
        refreshRate = "180";
        nvidiaSettings = {
          coordinate = {
            x = 0;
            y = 15;
          };
          forceFullCompositionPipeline = true;
          rotation = "normal";
        };
      }
      {
        name = "HDMI-0";
        resolution = "1920x1080";
        refreshRate = "75";
        scale = "1.1";
        nvidiaSettings = {
          coordinate = {
            x = 1920;
            y = 0;
          };
          forceFullCompositionPipeline = true;
          rotation = "normal";
        };
      }
    ];
  };
  base-modules = {
    nixos-modules =
      map mylib.file.relativeToRoot [
        "modules/secrets/nixos.nix"
        "modules/wallpaper/nixos.nix"
        "modules/nixos/desktop.nix"
        "modules/shared"
        "hosts/${name}"
      ]
      ++ [
        inputs.sops-nix.nixosModules.sops
      ];
    home-modules =
      map mylib.file.relativeToRoot [
        "hosts/${name}/home"
        "modules/home/linux/gui.nix"
        "modules/nupkgs/home.nix"
        "modules/colorscheme/home.nix"
        "modules/conf/home.nix"
        "modules/term.nix"
        "modules/shared"
      ]
      ++ [
        inputs.datsnvim.homeManagerModules.${system}.default
      ];
  };

  pc-modules = {
    nixos-modules =
      [
        {
          modules.shared.multi-monitors = monitorsConfig;
          modules.desktop.wallpaper = {
            enable = true;
            file = "/run/media/dtsf/datsgames/walls/46.png";
          };
          modules.ssh-key-manager.enable = true;
          modules.desktop.ollama.enable = false;
          modules.desktop.nvidia.enable = true;
          modules.desktop.xorg.enable = true;
          modules.desktop.wayland.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {
          modules.desktop.common-gui.enable = true;
          modules.shared.multi-monitors = monitorsConfig;
          modules.core.term.default = "alacritty";
          modules.desktop.i3.enable = true;
          modules.desktop.niri.enable = true;
          modules.desktop.nupkgs.enable = true;
          modules.desktop.conf = {
            enableDunstIntegration = true;
            enableCavaIntegration = true;
            enableZellijIntegration = true;
          };
          modules.desktop.colorscheme = {
            enable = true;
            enableDunstIntegration = true;
            enableNeovimIntegration = true;
            enableGTKIntegration = true;
            enableFishIntegration = true;
            enableCavaIntegration = true;
            enableZellijIntegration = true;
            enableAlacrittyIntegration = true;
            enableFzfIntegration = true;
            enableI3Integration = true;
            enableI3StatusIntegration = true;
          };
        }
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (pc-modules // args);
  };
}
