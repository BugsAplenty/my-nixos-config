{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.lazygit = {
    enable = true;
  };
}
