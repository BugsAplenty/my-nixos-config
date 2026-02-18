{ pkgs, ... }:

{
  programs.vscode = {
    enable  = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;   # Catppuccin writes a generated JSON

    profiles.default = {
      userSettings = {
        # ── theming ──────────────────────────────────
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme"  = "catppuccin-mocha";

        # ── fonts ────────────────────────────────────
        "editor.fontFamily" = "BigBlueTermPlus Nerd Font Mono";
        "editor.fontSize"   = 16;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "BigBlueTermPlus Nerd Font Mono";
        "terminal.integrated.fontSize"   = 16;

        # ── QoL tweaks ───────────────────────────────
        "files.autoSave"                      = "afterDelay";
        "files.autoSaveDelay"                 = 1000;
        "terminal.integrated.copyOnSelection" = true;
        "terminal.integrated.sendKeyBindingsToShell" = true;
        "editor.clipboard.copyWithSyntaxHighlighting" = true;

        # ── Jupyter / notebooks ──────────────────────
        # Keep notebook roots predictable
        "jupyter.notebookFileRoot" = "\${workspaceFolder}";
        # One interactive window per file (less clutter)
        "jupyter.interactiveWindowMode" = "perFile";
        # Avoid tiny clipped outputs
        "notebook.output.textLineLimit" = 10000;
        # Don’t nag for restarts on small kernel changes
        "jupyter.askForKernelRestart" = false;
        # Prefer built-in renderers (works well with Plotly + renderers ext)
        "notebook.experimental.outputScrolling" = true;
        # Make it obvious which env your kernel comes from
        "jupyter.enableKernelPickerInInteractiveWindow" = true;

        # ── Python ───────────────────────────────────
        "python.analysis.typeCheckingMode" = "basic";
        # Harmless if you launch via `nix develop -c codium .`
        "python.defaultInterpreterPath" = "\${workspaceFolder}/.venv/bin/python";
      };

      extensions = with pkgs.vscode-extensions; [
        # original toolchain
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        jnoortheen.nix-ide
        ms-toolsai.datawrangler

        # new themes & icons
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons

        # extra open-source goodies
        streetsidesoftware.code-spell-checker
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        platformio.platformio-vscode-ide
      ];
    };
  };
}
