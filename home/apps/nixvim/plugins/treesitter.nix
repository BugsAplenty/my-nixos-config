{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      indent = {
        enable = true;
        disable = [ "nix" ]; # nix treesitter indent is still off; use the builtin one
      };
    };
  };
}
