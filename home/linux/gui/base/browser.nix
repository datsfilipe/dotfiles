{ pkgs, lib, vars, ... }: {
  programs.chromium = {
    enable = true;
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
