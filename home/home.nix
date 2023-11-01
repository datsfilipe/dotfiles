{ config, ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    downloads = "${config.home.homeDirectory}/downloads";
    documents = "${config.home.homeDirectory}/documents";
    desktop = "${config.home.homeDirectory}/system/desktop";
    publicShare = "${config.home.homeDirectory}/system/public";
    templates = "${config.home.homeDirectory}/system/templates";
    music = "${config.home.homeDirectory}/media/music";
    pictures = "${config.home.homeDirectory}/media/photos";
    videos = "${config.home.homeDirectory}/media/videos";
  };
}
