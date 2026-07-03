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
      };
    };
  };
}
