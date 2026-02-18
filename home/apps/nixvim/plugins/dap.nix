{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins = {
    dap = {
      enable = true;
    };
    dap-lldb = {
      enable = true;
    };
    dap-go = {
      enable = true;
    };
    dap-ui = {
      enable = true;
      settings = {
        mappings = {
          edit = "e";
          expand = [ "<CR>" "<2-LeftMouse>" ];
          open = "o";
          remove = "d";
          repl = "r";
          toggle = "t";
        };
      };
    };
  };
}
