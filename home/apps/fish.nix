{ config, pkgs, lib, inputs, ... }:

{
  programs.fish = {
    enable = true;
    package = pkgs.fish;
  };
}
