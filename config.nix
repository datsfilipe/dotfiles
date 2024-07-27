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
      wall = "16.png";
      folder = "/run/media/dtsf/DATSFILES/wallpapers";
    };
    colorscheme = "eva";
  };
  applications = {
    browser = "chromium";
  };
  system = {
    load_nvidia_module = true;
  };
}
