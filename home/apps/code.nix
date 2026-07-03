{ pkgs, ... }:

{
  programs.vscodium = {
    enable = true;
    mutableExtensionsDir = false;

    profiles.default = {
      userSettings = {
        # ── theming ──────────────────────────────────
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";

        # ── fonts ────────────────────────────────────
        "editor.fontFamily" = "BigBlueTermPlus Nerd Font Mono";
        "editor.fontSize" = 16;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "BigBlueTermPlus Nerd Font Mono";
        "terminal.integrated.fontSize" = 16;

        # ── QoL tweaks ───────────────────────────────
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "terminal.integrated.copyOnSelection" = true;
        "terminal.integrated.sendKeyBindingsToShell" = true;
        "editor.clipboard.copyWithSyntaxHighlighting" = true;

        # ── Jupyter / notebooks ──────────────────────
        "jupyter.notebookFileRoot" = "\${workspaceFolder}";
        "jupyter.interactiveWindowMode" = "perFile";
        "notebook.output.textLineLimit" = 10000;
        "jupyter.askForKernelRestart" = false;
        "notebook.experimental.outputScrolling" = true;
        "jupyter.enableKernelPickerInInteractiveWindow" = true;

        # ── Python ───────────────────────────────────
        "python.analysis.typeCheckingMode" = "basic";
        "python.defaultInterpreterPath" = "\${workspaceFolder}/.venv/bin/python";
      };

      extensions = with pkgs.vscode-extensions; [
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        jnoortheen.nix-ide
        ms-toolsai.datawrangler
        ms-toolsai.jupyter  # ← ADD THIS LINE
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        streetsidesoftware.code-spell-checker
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        platformio.platformio-vscode-ide
        continue.continue
      ];
    };
  };
}
