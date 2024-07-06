{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-features=WebUIDarkMode"
    ];
    dictionaries = [ pkgs.hunspellDictsChromium.en_US ];
    extensions = [
      { id = "ajopnjidmegmdimjlfnijceegpefgped"; } # bttv
      { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # privacy badger
      { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # react devtools
      { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # google translate
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "pobhoodpcipjmedfenaigbeloiidbflp"; } # twitter minimal
      { id = "liecbddmkiiihnedobmlmillhodjkdmb"; } # loom
      { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # tampermonkey
      { id = "edacconmaakjimmfgnblocblbcdcpbko"; } # session buddy
      { id = "blkggjdmcfjdbmmmlfcpplkchpeaiiab"; } # omnivore
     
      { id = "lbhnkgjaoonakhladmcjkemebepeohkn"; } # vim tips in new tab
      { id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; } # vimium-C

      { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # metamask
    ];
  };
}
