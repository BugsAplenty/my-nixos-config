{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.neotest = {
    enable = true;
    adapters = {
      bash.enable = true;
      go.enable = true;
    };
  };
}
