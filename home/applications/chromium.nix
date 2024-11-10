{ pkgs, lib, vars, ... }:

with lib; mkIf (vars.applications.browser == "chromium") {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-features=WebUIDarkMode"
    ];
    dictionaries = [ pkgs.hunspellDictsChromium.en_US ];
    extensions = [
      { id = "ajopnjidmegmdimjlfnijceegpefgped"; } # bttv
      { id = "ammjkodgmmoknidbanneddgankgfejfh"; } # 7tv
      { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # react devtools
      { id = "pobhoodpcipjmedfenaigbeloiidbflp"; } # twitter minimal
      { id = "liecbddmkiiihnedobmlmillhodjkdmb"; } # loom
      { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # metamask
      { id = "dpjamkmjmigaoobjbekmfgabipmfilij"; } # new tab
    ];
  };
}
