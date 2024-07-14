{ pgks, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "zathura.desktop";
      "image/png" = "swayimg.desktop";
      "image/jpeg" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";
      "image/svg+xml" = "swayimg.desktop";
      "text/plain" = "nvim.desktop";
      "inode/directory" = "lf.desktop";
    };
  };
}
