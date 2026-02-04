{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.nixvim;
in
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  options.workstation.nixvim.enable =
    lib.mkEnableOption "Nvim configuration";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
	ripgrep
    ];

    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      opts = {
        number = true;
        relativenumber = true;
        clipboard = "unnamedplus";
      };

      globals.clipboard = {
        name = "wl-clipboard";
        copy = {
          "+" = [
            "wl-copy"
            "--type"
            "text/plain"
          ];
          "*" = [
            "wl-copy"
            "--type"
            "text/plain"
          ];
        };
        paste = {
          "+" = [
            "wl-paste"
            "--no-newline"
          ];
          "*" = [
            "wl-paste"
            "--no-newline"
          ];
        };
      };

      colorschemes.tokyonight.enable = true;

      plugins = {
        bufferline.enable = true;
        lualine.enable = true;
        mini.ai.enable = true;
        mini.pairs.enable = true;
        noice.enable = true;
        web-devicons.enable = true;

        treesitter = {
          enable = true;
          settings = {
            ensure_installed = [
              "bash"
              "html"
              "javascript"
              "json"
              "lua"
              "markdown"
              "markdown_inline"
              "nix"
              "python"
              "query"
              "regex"
              "rust"
              "tsx"
              "typescript"
              "vim"
              "yaml"
            ];
          };
        };

        treesitter-textobjects.enable = true;

        trouble = {
          enable = true;
          settings.use_diagnostic_signs = true;
        };

        which-key.enable = true;

        lsp = {
          enable = true;
          servers = {
            pyright.enable = true;
            ts_ls.enable = true;
            jsonls.enable = true;
          };
        };

        mason = {
          enable = true;
          ensureInstalled = [
            "stylua"
            "shellcheck"
            "shfmt"
            "flake8"
          ];
        };

        telescope.enable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [
        flash-nvim
        nui-nvim
        snacks-nvim
        ts-comments-nvim
        typescript-nvim
      ];

      extraConfigLua = ''
        -- flash.nvim
        require("flash").setup({})

        -- ts-comments
        require("ts-comments").setup({})

        -- Snacks configuration 
        local snacks = require("snacks")
        snacks.setup({
          lazy = {
            enabled = false,
          },
          dashboard = {
            enabled = true,
            width = 60,
            pane_gap = 4,
            autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
            preset = {
              pick = nil,
              keys = {
                { icon = " ", key = "f", desc = "Find File",  action = ":lua Snacks.dashboard.pick('files')" },
                { icon = " ", key = "n", desc = "New File",   action = ":ene | startinsert" },
                { icon = " ", key = "g", desc = "Find Text",  action = ":lua Snacks.dashboard.pick('live_grep')" },
                { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
              },
              header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
            },
            formats = {
              icon = function(item)
                if (item.file and item.icon == "file") or item.icon == "directory" then
                  return Snacks.dashboard.icon(item.file, item.icon)
                end
                return { item.icon, width = 2, hl = "icon" }
              end,
              footer = { "%s", align = "center" },
              header = { "%s", align = "center" },
              file = function(item, ctx)
                local fname = vim.fn.fnamemodify(item.file, ":~")
                fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                if #fname > ctx.width then
                  local dir = vim.fn.fnamemodify(fname, ":h")
                  local file = vim.fn.fnamemodify(fname, ":t")
                  if dir and file then
                    file = file:sub(-(ctx.width - #dir - 2))
                    fname = dir .. "/…" .. file
                  end
                end
                local dir, file = fname:match("^(.*)/(.+)$")
                return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
                  or { { fname, hl = "file" } }
              end,
            },
            sections = {
              { section = "header" },
              { section = "keys", gap = 1, padding = 1 },
            },
          },
          picker = {
            enabled = true,
            sources = {
              files = {
                hidden = true,
                ignored = false,
                exclude = { "**/.local/**", "**/.cache/**" },
              },
              grep = {
                hidden = true,
                ignored = false,
                exclude = { "**/.local/**", "**/.cache/**" },
              },
            },
          },
        })

        -- command and keymap for dashboard
        vim.api.nvim_create_user_command("SnacksDashboard", function()
          snacks.dashboard.open()
        end, {})

        vim.keymap.set("n", "<leader>sd", function()
          snacks.dashboard.open()
        end, { desc = "Snacks Dashboard" })
     '';
    };
  };
}
