{lib, ...}: rec {
  # Recursively find all files in 'dir' that end with 'suffix'
  scanPaths = dir: suffix: let
    files = builtins.readDir dir;

    # Find directories to recurse into
    dirs = lib.attrNames (lib.filterAttrs (name: type: type == "directory") files);

    # Find files that match the suffix
    matchedFiles = lib.attrNames (lib.filterAttrs (
        name: type:
          type == "regular" && lib.hasSuffix suffix name
      )
      files);

    currentPaths = map (f: dir + "/${f}") matchedFiles;
    recursivePaths = lib.concatMap (d: scanPaths (dir + "/${d}") suffix) dirs;
  in
    currentPaths ++ recursivePaths;

  # Convenience helper to resolve repo-root relative paths
  relativeToRoot = lib.path.append ../.;
}
