{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.helmWrapped
    pkgs.helmfileWrapped
  ];
}
