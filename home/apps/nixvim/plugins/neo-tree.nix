{ config, pkgs, lib, inputs, ... }:
{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
  };
}
