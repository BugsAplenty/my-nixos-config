{ pkgs, ... }:

{
  # ---- KDE Plasma 6 Packages ----
  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.spectacle
    kdePackages.gwenview
    kdePackages.dolphin-plugins
    kdePackages.ark
    
    # Theming Tools
    kdePackages.breeze-gtk
    kdePackages.qtstyleplugin-kvantum
    
    # Icons & Cursors (Reusing your favorites)
    papirus-icon-theme
    bibata-cursors
  ];

  programs = {
    plasma = {
      enable = true;
      shortcuts = {
        "kwin" = {
          "Overview" = "Meta";
          "KRunner" = "Alt+F2";
        };
        "org.kde.plasma.desktop" = {
          "Application Launcher" = "Alt+F1";
        };
      };
    };
  };

  # ---- GTK Theme Integration in KDE ----
  # This makes GTK apps (Chrome, Firefox, VS Code) look correct in Plasma
  gtk = {
    enable = true;
    theme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  # ---- Session Variables ----
  # Ensure apps use the right cursor and theme backend
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    GTK_USE_PORTAL = "1"; # Use native KDE file picker in GTK apps
  };
}
