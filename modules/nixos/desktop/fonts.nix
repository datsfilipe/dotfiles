{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      inter
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      serif = ["Inter"];
      sansSerif = ["Inter"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
