{
  user = "dtsf";
  host = "dtsf-machine";
  environment = {
    term = "wezterm";
    shell = "fish";
    multiplexer = "zellij";
    wm = "i3";
  };
  appearance = {
    bg = {
      wall = "23.png";
      folder = "/run/media/dtsf/dats-ext-files/wallpapers";
    };
    colorscheme = "catppuccin";
  };
  applications = {
    browser = "chromium";
  };
  system = {
    load_nvidia_module = true;
  };
}
