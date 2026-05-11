
{ config, pkgs, lib, inputs, ... }:

{
  home = {
    shell = {
      enableFishIntegration = true;
    };
    packages = with pkgs; [
      nordic
      papirus-icon-theme
      bibata-cursors
      nautilus
      pinentry-qt
      # gnome-tweaks
    ];
    username = "razboy";
    homeDirectory = "/home/razboy";
    stateVersion = "25.11";
    sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
      GTK_USE_PORTAL = "1";
      PINENTRY_KDE_USE_WALLET = "1";
    };
  };
  imports = [
    ./apps/nixvim/nixvim.nix
    ./apps/kitty.nix
    ./apps/code.nix
    # ./apps/firefox.nix
    ./apps/fish.nix
    ./apps/jq.nix
    ./apps/kde.nix
    # ./apps/gnome.nix
    ./apps/ripgrep.nix
    ./apps/zen.nix
  ];
  xdg = {
    configFile = {
      "plasma-workspace/env/hm-session-vars.sh".source = "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";
    };
  };
  programs = {
    git = {
      enable = true;
      userName = "BugsAplenty";
      userEmail = "28706245+BugsAplenty@users.noreply.github.com";
      signing = {
        key = "49211D602521B4C3";
        signByDefault = true;
      };
    };
    gpg = {
      enable = true;
    };
    btop = {
      package = pkgs.btop-cuda;
      enable = true;
      settings = {
        update_ms = 100;
        theme = "kyli0x";
      };
    };
    # aichat = {
    #   enable = true;
    #   settings = {
    #   	model = "gemma3:4b";
    #     clients = [{
    #       type = "ollama";  # Not "openai-compatible"
    #       name = "ollama";
    #       api_base = "http://localhost:11434";  # No /v1 suffix
	  # models = [
	  #   { 
    #     name = "gemma3:4b"; max_tokens = 8192;
    #   }
	  # ];
    #     }];
        
    #     default_client = "ollama";
    #   };
    # };
  };

  services = {
    ssh-agent = {
      enable = false;
    };
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry = {
        package = pkgs.pinentry-qt;
      };
    };
    ollama = {
      enable = true;
    };
    poweralertd = {
      enable = true;
    }; 
    mako = {
      settings = {
        enable = true;
        background-color = "#282828";
        text-color = "#ebdbb2";
        border-color = "#458588";
        default-timeout = 5000;
      };
    };
    gnome-keyring = {
      enable = true;
    };
  };
}
