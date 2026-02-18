{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      isDefault = true;

      settings = {
        # --- UI & FONTS ---
        "font.name.monospace.x-western" = "BigBlueTermPlus Nerd Font Mono";
        "browser.display.background_color" = "#16191C";
        "browser.display.foreground_color" = "#AAB2BF";
        "ui.systemUsesDarkTheme" = 1;
        "sidebar.verticalTabs" = true;

        # --- GRAPHICS (GPU) ---
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true; 
        "widget.dmabuf.force-enabled" = true;

        # --- THE 64GB RAM OPTIMIZATIONS ---
        
        # 1. CACHE: Move entirely to RAM
        "browser.cache.disk.enable" = false;              # Disable disk cache (saves SSD life too)
        "browser.cache.memory.enable" = true;             # Enable RAM cache
        "browser.cache.memory.capacity" = 4194304;        # Force 4GB RAM Cache (Value is in KB)
        "browser.cache.memory.max_entry_size" = 153600;   # Allow larger items (150MB) in RAM cache

        # 2. HISTORY: Keep more "live" pages in memory (Instant Back/Forward)
        "browser.sessionhistory.max_total_viewers" = 16;  # Default is often ~3-8. 16 is massive.
        "browser.sessionhistory.max_entries" = 50;        
        
        # 3. PROCESSES: Use more CPU/RAM for isolation
        "dom.ipc.processCount" = 16;                      # Default is 8. 16 reduces main thread contention.

        # 4. DISCARDING: Never unload tabs
        "browser.tabs.unloadOnLowMemory" = false;         # Your tabs will never reload when you switch back.
        "browser.low_commit_space_threshold_mb" = 32768;  # Only panic if we drop below 32GB free (lol)

        # --- NETWORK SPEED ---
        "network.http.http3.enable" = true;
        "network.dns.disablePrefetch" = true;
        "network.predictor.enabled" = false;
        
        # --- PRIVACY (Optimized for Speed) ---
        "privacy.resistFingerprinting" = false;           # DISABLE for 144hz+ smoothness
        "privacy.fingerprintingProtection" = true;        # Use the faster replacement
        "privacy.trackingprotection.enabled" = true;
        
        # --- BLOAT REMOVAL ---
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.startup.homepage" = "https://start.duckduckgo.com/";
      };
    };
  };
}
