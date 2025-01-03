{
  modules.desktop = {
    i3 = {
      settings = {
        window.titlebar = true;
      };
    };
  };

  programs.ssh = {
    enable = true;
    # extraConfig = ''
    #   Host github.com
    #       IdentityFile ~/.ssh/pkey
    #       IdentitiesOnly yes
    # '';
  };
}
