{ inputs, pkgs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.default ];

  programs.zen-browser = {
    enable = true;
    
    # Use the "Specific" package (Stable/Optimized) or "Twilight" (Beta/Nightly)
    package = inputs.zen-browser.packages."${pkgs.system}".twilight;

    # --- POLICIES (Extensions & Enterprise Settings) ---
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      
      # 64GB RAM TWEAKS (Injected via Policies -> Preferences)
      Preferences = {
        # CACHE: RAM ONLY
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = 4194304; # 4GB
        "browser.sessionhistory.max_total_viewers" = 16;
        "browser.tabs.unloadOnLowMemory" = false;

        # GRAPHICS
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        
        # PRIVACY
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = false; # Unlock 144hz
      };

      # DECLARATIVE EXTENSIONS
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
    
    # --- ZEN SPECIFIC (Workspaces & Themes) ---
    profiles.default = {
      id = 0;
      isDefault = true;
      
      # The flake might not support declarative spaces fully yet.
      # Let's REMOVE this block for now to get your build working.
      # You can create spaces manually in the browser once it launches.
      
      # spaces = { ... };  <-- DELETE OR COMMENT THIS ENTIRE BLOCK
      
      settings = {
        # Force the vertical tabs and theme settings here instead
        "zen.view.vertical-tabs" = true;
        "zen.view.compact" = true;
        "zen.theme.color" = "blue"; # Try setting color via pref if you want it
      };
    };
  };
}
