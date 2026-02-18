
{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.gitsigns = {
    enable = true;
  };
}
