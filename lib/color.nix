{
  lib,
  builtins,
  ...
}: let
  hexToDec = c: let
    hexChars = {
      "0" = 0;
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;
      "a" = 10;
      "b" = 11;
      "c" = 12;
      "d" = 13;
      "e" = 14;
      "f" = 15;
      "A" = 10;
      "B" = 11;
      "C" = 12;
      "D" = 13;
      "E" = 14;
      "F" = 15;
    };
  in
    hexChars.${c};
  decToHex = n:
    if n < 10
    then toString n
    else
      {
        "10" = "a";
        "11" = "b";
        "12" = "c";
        "13" = "d";
        "14" = "e";
        "15" = "f";
      }
      .${toString n};
  hexPairToDec = hex: hexToDec (builtins.substring 0 1 hex) * 16 + hexToDec (builtins.substring 1 1 hex);
  decToHexPair = n: decToHex (n / 16) + decToHex (n - (n / 16 * 16));

  darkenHex = hex: factor: let
    cleanHex = builtins.replaceStrings ["#"] [""] (lib.toLower hex);
    r = hexPairToDec (builtins.substring 0 2 cleanHex);
    g = hexPairToDec (builtins.substring 2 2 cleanHex);
    b = hexPairToDec (builtins.substring 4 2 cleanHex);

    darkR = builtins.ceil (r * (1 - factor));
    darkG = builtins.ceil (g * (1 - factor));
    darkB = builtins.ceil (b * (1 - factor));

    clamp = n:
      if n < 0
      then 0
      else if n > 255
      then 255
      else n;
  in
    "#" + decToHexPair (clamp darkR) + decToHexPair (clamp darkG) + decToHexPair (clamp darkB);
in {
  hexToDec = hexToDec;
  decToHex = decToHex;
  hexPairToDec = hexPairToDec;
  decToHexPair = decToHexPair;
  darkenHex = darkenHex;
}
