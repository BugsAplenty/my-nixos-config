{ config, pkgs, lib, ... }:

{
  # ---- Packages that make GNOME look/behave right ----
  home.packages = with pkgs; [
    nordic
    papirus-icon-theme
    bibata-cursors
    nautilus
    gnome-tweaks
    gnomeExtensions.user-themes
    gnomeExtensions.tiling-assistant
  ];

  # Make Nautilus the default file manager
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications."inode/directory" = [ "org.gnome.Nautilus.desktop" ];

  # ---- GNOME Shell extensions (correct HM shape) ----
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.user-themes; }
      { package = pkgs.gnomeExtensions.tiling-assistant; }
    ];
  };

  # ---- GTK + icon + cursor themes (installed + referenced) ----
  gtk = {
    enable = true;
    theme       = { package = pkgs.nordic;             name = "Nordic-darker"; };
    iconTheme   = { package = pkgs.papirus-icon-theme; name = "Papirus-Dark";  };
    cursorTheme = { package = pkgs.bibata-cursors;     name = "Bibata-Modern-Ice"; size = 24; };

    font = lib.mkDefault {
      name = "BigBlueTermPlus Nerd Font Mono";
      size = 14;
    };
  };

  # ---- Dconf: actually apply theme, enable extensions, hotkeys, tiling ----
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme    = "Nordic-darker";
      icon-theme   = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size  = 24;
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "tiling-assistant@leleat-on-github"
      ];
    };

    "org/gnome/shell/extensions/user-theme" = { name = "Nordic"; };

    # Quarter tiling (Tiling Assistant)
    "org/gnome/mutter" = { edge-tiling = true; };
    "org/gnome/shell/extensions/tiling-assistant" = {
      window-gap = 8;
      restore-window-size = true;

      tile-keys-left   = ["<Super><Ctrl>Left"];
      tile-keys-right  = ["<Super><Ctrl>Right"];
      tile-keys-top    = ["<Super><Ctrl>Up"];
      tile-keys-bottom = ["<Super><Ctrl>Down"];

      tile-keys-top-left     = ["<Super><Ctrl>q"];
      tile-keys-top-right    = ["<Super><Ctrl>w"];
      tile-keys-bottom-left  = ["<Super><Ctrl>a"];
      tile-keys-bottom-right = ["<Super><Ctrl>s"];
    };

    # Global terminal launcher — use kitty or gnome-terminal
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
      name = "Launch Terminal";
      command = "kitty";            # change to "gnome-terminal" if you prefer
      binding = "<Primary><Alt>t";  # Ctrl+Alt+T is reliable; Ctrl+T is usually eaten by apps
    };
  };

  # Help Xwayland/older toolkits see the cursor theme
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE  = "24";
  };

  # Optional: GNOME has notifications already; don't run mako here
  services.mako.enable = lib.mkForce false;
}
