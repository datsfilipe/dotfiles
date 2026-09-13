{lib, ...}: rec {
  scanPaths = dir: suffix: let
    files = builtins.readDir dir;

    dirs = lib.attrNames (lib.filterAttrs (_: type: type == "directory") files);

    matchedFiles = lib.attrNames (lib.filterAttrs (
        name: type:
          type == "regular" && lib.hasSuffix suffix name
      )
      files);

    currentPaths = map (f: dir + "/${f}") matchedFiles;
    recursivePaths = lib.concatMap (d: scanPaths (dir + "/${d}") suffix) dirs;
  in
    currentPaths ++ recursivePaths;

  relativeToRoot = lib.path.append ../.;

  substitute = path: vars:
    builtins.replaceStrings (lib.attrNames vars) (lib.attrValues vars) (builtins.readFile path);
}
