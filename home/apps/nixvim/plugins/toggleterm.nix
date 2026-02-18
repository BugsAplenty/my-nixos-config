{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.toggleterm = {
    enable = true;
  };
}
