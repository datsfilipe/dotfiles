{mylib, ...}: {
  imports = mylib.file.scanPaths ./.;
}
