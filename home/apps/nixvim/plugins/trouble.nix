
{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.trouble = {
    enable = true;
  };
}
