{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.barbar = {
    enable = true;
  };
}
