

{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.guess-indent = {
    enable = true;
  };
}
