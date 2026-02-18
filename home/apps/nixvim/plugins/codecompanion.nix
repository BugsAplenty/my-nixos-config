{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim = {
    # Enable the plugin but don't use settings
    plugins.codecompanion.enable = true;
    
    # Configure it with Lua directly
    extraConfigLua = ''
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "ollama",
          },
          inline = {
            adapter = "ollama",
          },
          agent = {
            adapter = "ollama",
          },
        },
        adapters = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  default = "qwen2.5-coder:7b",
                },
              },
            })
          end,
        },
      })
    '';
    
    keymaps = [
      {
        mode = "n";
        key = "<leader>ac";
        action = "<cmd>CodeCompanionChat<cr>";
        options = {
          desc = "Open AI Chat";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>ac";
        action = "<cmd>CodeCompanionChat Add<cr>";
        options = {
          desc = "Add selection to chat";
          silent = true;
        };
      }
      {
        mode = [ "n" "v" ];
        key = "<leader>aa";
        action = "<cmd>CodeCompanionActions<cr>";
        options = {
          desc = "AI Actions";
          silent = true;
        };
      }
    ];
  };
}
