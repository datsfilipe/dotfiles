{ lib, builtins, ... }: let
  formatSections = categories: attrs: let
    escapeValue = value:
      if builtins.isList value then
        "[\n  " + (lib.concatStringsSep ",\n  " (map (x: builtins.toJSON x) value)) + ",\n]"
      else if builtins.isInt value || builtins.isFloat value then
        toString value
      else if value == true then
        "true"
      else if value == false then
        "false"
      else
        ''"${value}"'';
        
    toIniLine = key: value:
      "${key}=${escapeValue value}";
        
    processAttributes = attributes:
      lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: toIniLine k v) attributes);
      
    effectiveCategories = if categories == null then lib.attrNames attrs else categories;
  in
    (if effectiveCategories == [] then
      processAttributes attrs
    else
      lib.concatStringsSep "\n\n" (
        map (category: ''
          [${category}]
          ${processAttributes (attrs.${category} or {})}
        '') effectiveCategories
      )) + "\n";
in {
  sections = formatSections;
}
