with builtins; let
  printChild = prefix: x: let
    names = attrNames x;
  in
    if isAttrs x && length names == 1
    then "." + head names + printChild prefix x.${head names}
    else " = " + print prefix x;

  hasPrefix = prefix: str:
    substring 0 (stringLength prefix) str == prefix;

  getSortPriority = name: value:
    if !isAttrs value || !(value ? url)
    then 3
    else if value ? url && length (attrNames value) == 1
    then 1
    else if hasPrefix "git+file" value.url
    then 4
    else 2;

  compareAttrs = a: b: let
    prioA = getSortPriority (head (attrNames a)) (a.${head (attrNames a)});
    prioB = getSortPriority (head (attrNames b)) (b.${head (attrNames b)});
  in
    if prioA == prioB
    then head (attrNames a) < head (attrNames b)
    else prioA < prioB;

  mapAttrsToList = f: attrs: let
    pairs = attrValues (mapAttrs (name: value: {${name} = value;}) attrs);
  in
    sort compareAttrs pairs;

  mapAttrsToLines = f: attrs:
    concatStringsSep "\n"
    (map (pair: let
      name = head (attrNames pair);
      value = pair.${name};
    in
      f name value)
    (mapAttrsToList f attrs));

  print = prefix: x:
    if isString x
    then "\"${x}\""
    else if x == null
    then "null"
    else if x == false
    then "false"
    else if ! isAttrs x
    then toString x
    else let
      prefix' = prefix + "  ";
    in ''
      {
        ${mapAttrsToLines (n: v: prefix' + n + printChild prefix' v + ";") x}
        ${prefix}}'';
in
  print
