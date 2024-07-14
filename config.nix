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
      wall = "19.png";
      folder = "/run/media/dtsf/DATSFILES/wallpapers";
    };
    colorscheme = "gruvbox";
  };
  applications = {
    browser = "chromium";
  };
  system = {
    load_nvidia_module = true;
  };
}
