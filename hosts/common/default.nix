{
  wallpaper = "/run/media/dtsf/datsgames/walls/46.png";
  theme = "gruvbox";

  monitors = {
    pc = [
      {
        name = "DP-2";
        focus = true;
        resolution = "1920x1080";
        refreshRate = "180";
        nvidiaSettings = {
          coordinate = {
            x = 0;
            y = 15;
          };
          forceFullCompositionPipeline = true;
          rotation = "normal";
        };
      }
      {
        name = "HDMI-0";
        resolution = "1920x1080";
        refreshRate = "75";
        scale = "1.1";
        nvidiaSettings = {
          coordinate = {
            x = 1920;
            y = 0;
          };
          forceFullCompositionPipeline = true;
          rotation = "normal";
        };
      }
    ];

    laptop = [
      {
        name = "eDP-1";
        resolution = "1920x1080";
        refreshRate = "59.997";
        scale = "1.3";
        nvidiaSettings = {
          coordinate = {
            x = 0;
            y = 0;
          };
          forceFullCompositionPipeline = true;
          rotation = "normal";
        };
      }
    ];
  };
}
