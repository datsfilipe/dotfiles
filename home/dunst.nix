let colors = import ../modules/colorschemes.nix;
in {
  xdg.configFile."dunst/dunstrc".text = ''
    [global]
      monitor = 0
      follow = mouse
      shrink = no
      padding = 20
      horizontal_padding = 20
      
      width = 275
      height = 100
      offset = 10x50
      origin = bottom-right

      frame_width = 0
      separator_height = 0
      frame_color = "${colors.scheme.eva.bg}"
      separator_color = "${colors.scheme.eva.bg}"

      sort = no
      font = JetBrainsMono Nerd Font 10
      markup = full
      format = "<b>%s</b>\n%b"
      alignment = left
      show_age_threshold = 60
      word_wrap = yes
      ignore_newline = no
      stack_duplicates = true
      hide_duplicate_count = no
      show_indicators = yes

      icon_position = left
      max_icon_size= 60
      sticky_history = no
      history_length = 6
      title = Dunst
      class = Dunst
      corner_radius = 4

      mouse_left_click = close_current
      mouse_middle_click = do_action
      mouse_right_click = close_all

    [urgency_low]
      background = "${colors.scheme.eva.bg}"
      foreground = "${colors.scheme.eva.red}"
      timeout = 5

    [urgency_normal]
      background = "${colors.scheme.eva.bg}"
      foreground = "${colors.scheme.eva.red}"
      timeout = 10

    [urgency_critical]
      background = "${colors.scheme.eva.red}"
      foreground = "${colors.scheme.eva.bg}"
      timeout = 20
  '';
}
