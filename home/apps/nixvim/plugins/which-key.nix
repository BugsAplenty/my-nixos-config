{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins = {
    which-key = {
      enable = true;
    };
  };
}
