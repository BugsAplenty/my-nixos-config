# plugins/cmp.nix  ─ consolidated & correct paths
{ ... }:

{
  programs.nixvim.plugins.cmp = {
    enable = true;

    settings = {
      ########################################################################
      # A. Sources  (LLM last, Copilot‑style)
      ########################################################################
      sources = [
        { name = "nvim_lsp";  priority = 1000; }
        { name = "path";      priority = 750;  }
        { name = "buffer";    priority = 500;  }
        { name = "llm";       priority = 250; keyword_length = 8; }
      ];

      ########################################################################
      # B. Key‑mappings  (<CR> to confirm, Tab handled by llm.nvim)
      ########################################################################
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-n>"     = "cmp.mapping.select_next_item()";
        "<C-p>"     = "cmp.mapping.select_prev_item()";
        "<C-f>"     = "cmp.mapping.scroll_docs(4)";
        "<C-b>"     = "cmp.mapping.scroll_docs(-4)";
        "<C-e>"     = "cmp.mapping.abort()";
        "<CR>"      = "cmp.mapping.confirm({ select = true })";
      };
    };
  };
}
