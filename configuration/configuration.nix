{ config, lib, pkgs, ... }:

let
  # Helper: shorter alias for lib.mkIf inside option sets
  when = lib.mkIf;
  user = "razboy";
  home = "/home/${user}";
in
{
  ##############################################################################
  # ░░ Core                             ░░
  ##############################################################################
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];
  system.stateVersion = "25.11";
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      extra-platforms = [ "aarch64-linux" ];
      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
  };

  boot = {
    plymouth = {
      enable = lib.mkForce false;
    };
    binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
    };
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;  # keep last 10 generations in boot menu
    };
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [
      "kvm"
      "kvm-intel"
    ];
  };
  
  time.timeZone = "America/Toronto";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
      "he_IL.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  console.keyMap = "us";

  ##############################################################################
  # ░░ User Accounts                    ░░
  ##############################################################################
  users.users.razboy = {
    isNormalUser = true;
    description  = "razboy";
    extraGroups  = [ 
      "wheel" 
      "networkmanager" 
      "audio" 
      "dialout" 
      "uucp" 
      "plugdev" 
      "kvm"
      "libvirtd"
    ];
    shell        = pkgs.fish;
  };

  ##############################################################################
  # ░░ Networking                       ░░
  ##############################################################################
  networking = {
    firewall = {
      allowedUDPPorts = [ 12345 12346 8888 8889 ];
    };
    hostName = "nixos";
    wireless = {
      enable = false;
    };
    networkmanager = {
      enable = true;
    };
    nameservers = [
      "192.168.42.1"
    ];
  };
  security = {
    pam = {
      services = {
        login = {
	  kwallet = {
	    enable = true;
	  };
	};
      };
    };
  };
  # Virtualization
  virtualisation.libvirtd.enable = true;

  ##############################################################################
  # ░░ NVIDIA & CUDA                    ░░
  ##############################################################################
  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaSettings = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        offload = {
          enable = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    rtl-sdr = {
      enable = true;
    };
  };

  ##############################################################################
  # ░░ Desktop & Login                  ░░
  ##############################################################################
  programs = {
    # dconf = {
    #   enable = true;
    # };
    virt-manager = {
      enable = true;
    };
    xwayland = {
      enable = true;
    };
  };

  services = {
    searx = {
      enable = true;
      package = pkgs.searxng;
      redisCreateLocally = true;
      environmentFile = "/etc/searxng.env"; # create with: SEARXNG_SECRET=$(openssl rand -hex 32)
      settings = {
        server = {
          bind_address = "127.0.0.1";
          port = 8888;
        };
        search.formats = [ "html" "json" ];
      };
    };
    open-webui = {
      enable = true;
      host = "127.0.0.1";
      port = 6969;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        WEBUI_AUTH = "False"; # set to "True" if you want a login
        ENABLE_RAG_WEB_SEARCH = "True";
        RAG_WEB_SEARCH_ENGINE = "searxng";
        SEARXNG_QUERY_URL = "http://127.0.0.1:8888/search?q=<query>&format=json";
      };
    };
    asusd = {
      enable = true;
    };
    teamviewer = {
      enable = true;
    };
    desktopManager = {
      # gnome = {
      #   enable = true;
      # };
      plasma6 = {
        enable = true;
      };
    };
    displayManager = {
      # gdm = {
      #   enable = true;
      # };
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      xkb = {
        options = "grp:alt_shift_toggle";
        layout = "us,il,ru";
      };
    };
    resolved = {
      enable = false;
    };
    dbus = {
      enable = true;
    };
    upower = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    seatd.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
    
    # Misc services
    expressvpn.enable = true;
    fwupd.enable      = true;
    printing.enable   = true;
  };

  ##############################################################################
  # ░░ Applications & Packages          ░░
  ##############################################################################
  nixpkgs.config.allowUnfree = true;
  programs = {
    fish.enable     = true;
    firefox.enable  = true;
    steam.enable    = true;  # pulls both client & runtime
  };
  
  environment.systemPackages = with pkgs; [
    minicom
    blender
    audacity
    k9s
    git 
    vim 
    neovim 
    wget 
    tree 
    unzip 
    neofetch 
    wl-clipboard 
    gdb 
    busybox 
    exfatprogs 
    qemu
    mosquitto
    sshfs 
    rclone
    gcc 
    tcpdump
    winetricks
    wineWowPackages.stable
    xournalpp
    xclip
    platformio
    llvmPackages.clang 
    llvmPackages.clang-tools 
    lldb
    heroic
    zig 
    cmake 
    ninja 
    nodejs 
    python3 
    poetry
    # multimedia & misc
    bitwig-studio5-unwrapped 
    carla 
    vlc 
    gimp 
    evince 
    jdk21
    telegram-desktop 
    prismlauncher
    nordic 
    discord
    inxi
    expressvpn
    gtt 
    w3m
    orca-slicer
    kubectl 
    kubernetes-helm 
    openssl 
    nmap 
    avahi 
    ethtool 
    arp-scan 
    home-manager
    pciutils
    usbutils
    openmw 
    portmod 
    speedtest 
    baobab 
    unrar
    kdePackages.kwallet-pam
    rpi-imager
    parted
    alsa-utils 
    alsa-tools 
    helvum 
    qpwgraph 
    pulseaudioFull 
    dig 
    helmfile
    patchelf
    zenity
    local-ai
    esptool
    esphome
    qbittorrent
    openscad
    freecad
    lollypop
    sdrpp
    rtl-sdr
    gnumake
    pkg-config
    file
    cairo
    cargo
    teamviewer
    uv
    ticker
    ghostscript
    qpdf
  ];

  ##############################################################################
  # ░░ Fonts                            ░░
  ##############################################################################
  fonts = {
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      monospace = [ "BigBlueTermPlus Nerd Font Mono" ];
      sansSerif = [ "BigBlueTermPlus Nerd Font" ];
      serif     = [ "BigBlueTermPlus Nerd Font" ];
    };

    # ── the important part ──
    packages =
      with pkgs; [
        nerd-fonts.bigblue-terminal
        material-design-icons
        culmus
        noto-fonts
        noto-fonts-emoji
      ];
  };
}
