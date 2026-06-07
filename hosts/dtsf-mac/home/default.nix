{
  lib,
  mylib,
  myvars,
  ...
}: {
  imports = (mylib.file.scanPaths ../../../modules "user.nix") ++ [./packages.nix ./wallpaper.nix];

  modules.hardware.machine.hostname = "dtsf-mac";

  modules.core.shell.fish.user.enable = true;
  modules.core.user.home.enable = true;

  modules.desktop.conf = {
    enableZellijIntegration = true;
    enableBottomIntegration = true;
  };

  modules.desktop.nupkgs.enable = true;
  modules.programs.tools.user.enable = true;
  modules.programs.devtools.user.enable = false;
  modules.programs.bottom.user.enable = true;

  modules.programs.git.enable = true;
  modules.programs.terminal.default = "alacritty";
  modules.programs.terminal.alacritty.enableDecorations = true;

  modules.editors.neovim.user.enable = true;

  # neovim/os.nix (which sets EDITOR) isn't imported on darwin, so set it here.
  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  modules.desktop.colorscheme = {
    enable = true;
    enableNeovimIntegration = true;
    enableFishIntegration = true;
    enableAlacrittyIntegration = true;
    enableFzfIntegration = true;
    enableZellijIntegration = true;
  };

  modules.themes.${myvars.hostsConfig.theme}.enable = true;
}
