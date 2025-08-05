return {
  {
    "Mofiqul/dracula.nvim",
    config = function()
      local colors = require("dracula.palette-soft")
      -- local colors = require("dracula").colors()
      require("dracula").setup({
        theme = "dracula-soft",
        overrides = {
          NormalNC = { bg = colors.menu },
          ["@function.builtin"] = { fg = colors.pink },
          ["@property"] = { fg = colors.fg },
          ["@type.builtin"] = { fg = colors.pink, italic = false },
          ["@lsp.type.enum"] = { fg = colors.cyan, italic = true },
          ["@lsp.type.enumMember"] = { fg = colors.fg },
          ["@lsp.type.macro"] = { fg = colors.green },
          ["@lsp.type.namespace"] = { fg = colors.fg },
          ["@lsp.type.parameter"] = { fg = colors.orange, italic = true },
          ["@lsp.type.property"] = { fg = colors.fg },
          ["@lsp.type.type"] = { fg = colors.bright_cyan, italic = true },
          ["@lsp.type.typeParameter"] = { fg = colors.bright_cyan, italic = true },
          ["@lsp.typemod.variable.readonly"] = { fg = colors.purple },
          ["@lsp.typemod.property.readonly"] = { fg = colors.purple },
        },
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula-soft",
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          header = false,
          border = "rounded",
        },
        virtual_text = false,
      },
      servers = {
        ruff = {
          -- don't let mason manage ruff, it's not good at it.
          mason = false,
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 200 },
    },
    keys = {
      {
        "<leader>gt",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle current line blame",
      },
    },
  },
  -- Errors in zig code
  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },
  -- Add borders to completion windows
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
      signature = { window = { border = "rounded" } },
    },
  },
  -- Let's try remote nvim
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    opts = {
      client_callback = function(port, workspace_config)
        local cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s"):format(
          port,
          ("'Remote: %s'"):format(workspace_config.host)
        )
        vim.fn.jobstart(cmd, {
          detach = true,
          on_exit = function(job_id, exit_code, event_type)
            -- This function will be called when the job exits
            print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
          end,
        })
      end,
      remote = {
        copy_dirs = {
          config = {
            compression = {
              enabled = true,
              additional_opts = { "--exclude-vcs" },
            },
          },
        },
      },
    },
  },
}
