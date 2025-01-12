{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ffmpeg-full
    imagemagick
  ];
}
