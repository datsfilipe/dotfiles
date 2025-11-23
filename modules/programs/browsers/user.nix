{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.browsers.user;
in {
  options.modules.programs.browsers.user.enable = mkEnableOption "Browser setup (Brave via chromium module)";

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
      dictionaries = [pkgs.hunspellDictsChromium.en_US];
      extensions = [
        {id = "ajopnjidmegmdimjlfnijceegpefgped";} # bttv
        {id = "ammjkodgmmoknidbanneddgankgfejfh";} # 7tv
        {id = "fmkadmapgofadopljbjfkapdkoienihi";} # react devtools
        {id = "pobhoodpcipjmedfenaigbeloiidbflp";} # twitter minimal
        {id = "liecbddmkiiihnedobmlmillhodjkdmb";} # loom
        {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # metamask
        {id = "dpjamkmjmigaoobjbekmfgabipmfilij";} # new tab
      ];
    };
  };
}
