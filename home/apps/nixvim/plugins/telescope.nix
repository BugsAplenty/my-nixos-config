{ config, pkgs, lib, inputs, ... }:
{
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      file-browser.enable = true;
      fzy-native.enable = true;
      ui-select.enable = true;
    };
    settings = {
      defaults = {
        mappings = {
          i = {
            "<C-j>" = "move_selection_next";
          };
        };
      };
    };
  };
}

