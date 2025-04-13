{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    xdg-utils
    xdg-user-dirs
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    mimeApps = {
      enable = true;
      defaultApplications = let
        browser = ["chromium.desktop"];
        editor = ["nvim.desktop"];
      in {
        "application/json" = browser;
        "application/pdf" = browser;

        "text/html" = browser;
        "text/xml" = browser;
        "text/plain" = editor;
        "application/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/rdf+xml" = browser;
        "application/rss+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-wine-extension-ini" = editor;

        "x-scheme-handler/about" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;

        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop "];

        "audio/*" = ["mpv.desktop"];
        "video/*" = ["mpv.desktop"];
        "image/*" = ["imv-dir.desktop"];
        "image/gif" = ["imv-dir.desktop"];
        "image/jpeg" = ["imv-dir.desktop"];
        "image/png" = ["imv-dir.desktop"];
        "image/webp" = ["imv-dir.desktop"];
      };

      associations.removed = {};
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      download = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/documents";
      desktop = "${config.home.homeDirectory}/system/desktop";
      publicShare = "${config.home.homeDirectory}/system/public";
      templates = "${config.home.homeDirectory}/system/templates";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/photos";
      videos = "${config.home.homeDirectory}/media/videos";
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
      };
    };
  };
}
