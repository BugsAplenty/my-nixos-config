{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "BigBlueTermPlus Nerd Font Mono";
      package = pkgs.nerd-fonts.bigblue-terminal;
      size = 12;
    };
    settings = {
      background_opacity = "0.9";
      cursor_shape = "underline";
      enable_audio_bell = "no";
      confirm_os_window_close = 0;
    };
    themeFile = "AdventureTime";
  };
}
