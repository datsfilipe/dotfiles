{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
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
  ];
}
