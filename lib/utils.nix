{ lib, builtins, ... }:

with lib; let
  if_let = v: p: if attrsets.matchAttrs p v then v else null;
  match = v: l: builtins.elemAt
    (
      lists.findFirst
        (
          x: (if_let v (builtins.elemAt x 0)) != null
        )
        null
        l
    ) 1;
in
{
  if_let = if_let;
  match = match;
  removeHash =
    str: builtins.replaceStrings [ "#" ] [ "" ] str;
}
