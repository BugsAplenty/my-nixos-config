{ config, pkgs, lib, inputs, ... }:

let
  flakePath = "${config.home.homeDirectory}/my-config";
in
{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      clangd = {
        enable = true;
        cmd = [
          "clangd"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--all-scopes-completion"
          "--pch-storage=memory"
          "--compile-commands-dir=build"
        ];
      };
      cmake = {
        enable = true;
      };
      pyright = {
        enable = true;
      };
      nixd = {
        enable = true;
        settings = {
          nixpkgs = {
            expr = "import <nixpkgs> {}";
          };
          options = {
            nixos = {
              expr = "(builtins.getFlake \"${flakePath}\").nixosConfigurations.myhostname.options";
            };
            home-manager = {
              expr = "(builtins.getFlake \"${flakePath}\").homeConfigurations.razboy.options";
            };
          };
        };
      };
    };
  };
}
