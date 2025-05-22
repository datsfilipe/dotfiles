{
  lib,
  myvars,
  mylib,
  system,
  inputs,
  genSpecialArgs,
  ...
} @ args: let
  name = "dtsf-laptop";
  monitorsConfig = {
    enable = true;
    enableNvidiaSupport = false;
    monitors = [
      {
        name = "eDP-1";
        resolution = "1920x1080";
        refreshRate = "59.997";
        scale = "1.5";
        nvidiaSettings = {
          coordinate = {
            x = 0;
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
            file = "/home/${myvars.username}/media/photos/28.png";
          };
          modules.ssh-key-manager.enable = true;
          modules.desktop.ollama.enable = false;
          modules.desktop.nvidia.enable = false;
          modules.desktop.wayland.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {
          modules.shared.multi-monitors = monitorsConfig;
          modules.core.term.default = "ghostty";
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
            enableAstalIntegration = true;
            enableGhosttyIntegration = true;
            enableFzfIntegration = true;
            enableNiriIntegration = true;
            enableFuzzelIntegration = true;
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
