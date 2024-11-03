{
  user = "dtsf";
  environment = {
    term = "alacritty";
    shell = "fish";
    multiplexer = "zellij";
    desktop = "i3";
  };
  appearance = {
    bg = {
      wall = "27.png";
      folder = "/run/media/dtsf/dats-ext-files/wallpapers";
    };
    colorscheme = "catppuccin";
  };
  applications = {
    browser = "chromium";
  };
  system = {
    load_nvidia_module = false;
    boot = "grub";
    dpi = "96";
  };
}
