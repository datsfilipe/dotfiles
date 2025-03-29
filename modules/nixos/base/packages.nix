{
  pkgs,
  lib,
  vars,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gcc
    strace
    tcpdump
    lsof
    sysstat
    iotop
    iftop
    btop
    psmisc
    lm_sensors
    ethtool
    pciutils
    usbutils
    parted
    openvpn
  ];
}
