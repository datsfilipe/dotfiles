{
  user = "dtsf";
  environment = {
    term = "wezterm";
    shell = "fish";
    multiplexer = "zellij";
    wm = "i3";
  };
  appearance = {
    bg = {
      wall = "26.png";
      folder = "/run/media/dtsf/dats-ext-files/wallpapers";
    };
    colorscheme = "eva";
  };
  applications = {
    browser = "chromium";
  };
  system = {
    load_nvidia_module = true;
    ollama = true;
    boot = "grub";
    dpi = "96";
  };
}
