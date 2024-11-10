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
      wall = "28.png";
      folder = "/run/media/dtsf/dats-ext-files/wallpapers";
    };
    colorscheme = "vesper";
  };
  applications = {
    browser = "chromium";
  };
  system = {
    boot = "systemd";
    boot_timeout = 0;
    load_nvidia_module = false;
    dpi = "96";
  };
}
