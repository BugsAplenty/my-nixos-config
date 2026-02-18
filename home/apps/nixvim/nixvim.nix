{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins/lualine.nix
    ./plugins/web-devicons.nix
    ./plugins/treesitter.nix
    ./plugins/telescope.nix
    ./plugins/trouble.nix
    ./plugins/lazygit.nix
    ./plugins/dap.nix
    ./plugins/neotest.nix
    ./plugins/neoscroll.nix
    ./plugins/neo-tree.nix
    ./plugins/gitsigns.nix
    ./plugins/lsp.nix
    ./plugins/cmp.nix
    ./plugins/luasnip.nix
    ./plugins/which-key.nix
    ./plugins/barbar.nix
    ./plugins/toggleterm.nix
    ./plugins/codecompanion.nix
  ];
  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };
    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      cursorline = true;
      termguicolors = true;
      splitright = true;
      splitbelow = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      timeoutlen = 400;
    };
    extraPackages = with pkgs; [
      clang-tools
      cmake
      cmake-language-server
      ninja
      gdb
      lldb
      pkg-config
    ];
    extraPlugins =
      let
        vimPlugins = pkgs.vimPlugins;
        cmakePlugin =
          if builtins.hasAttr "cmake-tools-nvim" vimPlugins then
            vimPlugins.cmake-tools-nvim
          else if builtins.hasAttr "cmake-tools" vimPlugins then
            vimPlugins.cmake-tools
          else
            null;
      in
      lib.optional (cmakePlugin != null) cmakePlugin;
    extraConfigLua = ''
      local ok_cmake, cmake = pcall(require, "cmake-tools")
      if ok_cmake then
        cmake.setup({
          cmake_command = "cmake",
          cmake_build_directory = "build",
          cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
          cmake_soft_link_compile_commands = true,
        })
      else
        if vim.fn.exists(":CMakeGenerate") == 0 then
          vim.g.cmake_build_type = vim.g.cmake_build_type or "Debug"
          vim.g.cmake_build_target = vim.g.cmake_build_target or ""

          vim.api.nvim_create_user_command("CMakeSelectBuildType", function()
            local bt = vim.fn.input("CMake build type: ", vim.g.cmake_build_type)
            if bt ~= "" then
              vim.g.cmake_build_type = bt
            end
          end, {})

          vim.api.nvim_create_user_command("CMakeSelectTarget", function()
            local target = vim.fn.input("CMake target (empty for default): ", vim.g.cmake_build_target)
            vim.g.cmake_build_target = target or ""
          end, {})

          vim.api.nvim_create_user_command("CMakeGenerate", function()
            local cmd = {
              "cmake",
              "-S",
              ".",
              "-B",
              "build",
              "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
              "-DCMAKE_BUILD_TYPE=" .. vim.g.cmake_build_type,
            }
            vim.cmd("!" .. table.concat(cmd, " "))
          end, {})

          vim.api.nvim_create_user_command("CMakeBuild", function()
            local cmd = { "cmake", "--build", "build" }
            if vim.g.cmake_build_target ~= "" then
              table.insert(cmd, "--target")
              table.insert(cmd, vim.g.cmake_build_target)
            end
            vim.cmd("!" .. table.concat(cmd, " "))
          end, {})

          vim.api.nvim_create_user_command("CMakeRun", function()
            local target = vim.g.cmake_build_target
            if target == "" then
              target = vim.fn.input("Executable path: ", vim.fn.getcwd() .. "/build/", "file")
            else
              target = vim.fn.getcwd() .. "/build/" .. target
            end
            vim.cmd("!" .. vim.fn.shellescape(target))
          end, {})

          vim.api.nvim_create_user_command("CMakeDebug", function()
            local ok_dap, dap = pcall(require, "dap")
            if ok_dap then
              dap.continue()
            end
          end, {})
        end
      end

      local ok_dap, dap = pcall(require, "dap")
      local ok_dapui, dapui = pcall(require, "dapui")
      if ok_dap and ok_dapui then
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end

        dap.configurations.cpp = dap.configurations.cpp or {}
        table.insert(dap.configurations.cpp, {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
          end,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          args = {},
        })
        dap.configurations.c = dap.configurations.cpp
      end
    '';
    colorschemes = {
      dracula-nvim = {
        enable = true;
      };
    };
    clipboard = {
      providers = {
        wl-copy = {
          enable = true;
        };
      };
      register = "unnamedplus";
    };
    keymaps = [
      {
        mode = "n";
        key = "<C-m>";
        action = "<cmd>make<CR>";
        options = {
          silent = true;
          desc = "Run make";
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file tree";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>ToggleTerm<CR>";
        options.desc = "Toggle terminal";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<CR>";
        options.desc = "Help tags";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Telescope oldfiles<CR>";
        options.desc = "Recent files";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move to left window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move to right window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move to below window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move to above window";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = ":bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = ":bprevious<CR>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "LSP definition";
      }
      {
        mode = "n";
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
        options.desc = "LSP declaration";
      }
      {
        mode = "n";
        key = "gi";
        action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
        options.desc = "LSP implementation";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        options.desc = "LSP references";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "LSP hover";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "LSP rename";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "LSP code action";
      }
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
        options.desc = "Format buffer";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Prev diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }
      {
        mode = "n";
        key = "<leader>dq";
        action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
        options.desc = "Diagnostics list";
      }
      {
        mode = "n";
        key = "<F5>";
        action = "<cmd>lua require('dap').continue()<CR>";
        options.desc = "DAP continue";
      }
      {
        mode = "n";
        key = "<F10>";
        action = "<cmd>lua require('dap').step_over()<CR>";
        options.desc = "DAP step over";
      }
      {
        mode = "n";
        key = "<F11>";
        action = "<cmd>lua require('dap').step_into()<CR>";
        options.desc = "DAP step into";
      }
      {
        mode = "n";
        key = "<F12>";
        action = "<cmd>lua require('dap').step_out()<CR>";
        options.desc = "DAP step out";
      }
      {
        mode = "n";
        key = "<F9>";
        action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
        options.desc = "DAP toggle breakpoint";
      }
      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
        options.desc = "DAP toggle breakpoint";
      }
      {
        mode = "n";
        key = "<leader>dr";
        action = "<cmd>lua require('dap').repl.open()<CR>";
        options.desc = "DAP REPL";
      }
      {
        mode = "n";
        key = "<leader>dl";
        action = "<cmd>lua require('dap').run_last()<CR>";
        options.desc = "DAP run last";
      }
      {
        mode = "n";
        key = "<leader>du";
        action = "<cmd>lua require('dapui').toggle()<CR>";
        options.desc = "DAP UI toggle";
      }
      {
        mode = "n";
        key = "<leader>cg";
        action = "<cmd>CMakeGenerate<CR>";
        options.desc = "CMake generate";
      }
      {
        mode = "n";
        key = "<leader>cb";
        action = "<cmd>CMakeBuild<CR>";
        options.desc = "CMake build";
      }
      {
        mode = "n";
        key = "<leader>cr";
        action = "<cmd>CMakeRun<CR>";
        options.desc = "CMake run";
      }
      {
        mode = "n";
        key = "<leader>cd";
        action = "<cmd>CMakeDebug<CR>";
        options.desc = "CMake debug";
      }
      {
        mode = "n";
        key = "<leader>ct";
        action = "<cmd>CMakeSelectTarget<CR>";
        options.desc = "CMake target";
      }
      {
        mode = "n";
        key = "<leader>cs";
        action = "<cmd>CMakeSelectBuildType<CR>";
        options.desc = "CMake build type";
      }
    ];

  };
}
