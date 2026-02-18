
{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.luasnip = {
    enable = true;
  };
}
