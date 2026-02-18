{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.lualine = {
    enable = true;
    # Additional configuration options
  };
}
