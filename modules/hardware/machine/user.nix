{lib, ...}:
with lib; {
  options.modules.hardware.machine = {
    hostname = mkOption {
      type = types.str;
    };
  };
}
