{ config, pkgs, lib, inputs, ... }:
{
  programs.nixvim.plugins.neoscroll = {
    enable = true;
  };
}
