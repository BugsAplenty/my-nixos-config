{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim = {
    plugins.codecompanion = {
      enable = true;
      settings = {
        adapters = {
          ollama = ''
            function()
              return require("codecompanion.adapters").use("ollama", {
                env = {
                  url = "http://192.168.42.163:3000/v1",
                },
                schema = {
                  model = {
                    default = "qwen3.6:35b",
                  },
                  num_ctx = {
                    default = 16384,
                  },
                  keep_alive = {
                    default = "10m",
                  },
                },
              })
            end
          '';
        };

        strategies = {
          chat.adapter = "ollama";
          inline.adapter = "ollama";
          cmd.adapter = "ollama";
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ac";
        action = "<cmd>CodeCompanionChat<CR>";
        options = {
          desc = "Open AI chat";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>ac";
        action = "<cmd>CodeCompanionChat Add<CR>";
        options = {
          desc = "Add selection to chat";
          silent = true;
        };
      }
      {
        mode = [ "n" "v" ];
        key = "<leader>aa";
        action = "<cmd>CodeCompanionActions<CR>";
        options = {
          desc = "AI actions";
          silent = true;
        };
      }
      {
        mode = [ "n" "v" ];
        key = "<leader>ai";
        action = "<cmd>CodeCompanion<CR>";
        options = {
          desc = "Inline AI";
          silent = true;
        };
      }
    ];
  };
}
