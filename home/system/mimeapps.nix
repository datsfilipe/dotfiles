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
      "inode/directory" = "felix.desktop";
      "text/plain" = "nvim.desktop";
    };
  };
}
