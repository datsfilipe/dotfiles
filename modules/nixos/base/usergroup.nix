{
  myvars,
  config,
  ...
}: {
  users.groups = {
    "${myvars.username}" = {};
    docker = {};
    uinput = {};
  };

  users.users."${myvars.username}" = {
    home = "/home/${myvars.username}";
    isNormalUser = true;
    extraGroups = [
      myvars.username
      "users"
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "video"
    ];
    linger = false;
  };
}
