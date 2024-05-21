return {
  -- Disable animation for indent guides
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },
  -- Auto-save sessions
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "/" },
    },
    keys = {
      {
        "<leader>fs",
        function()
          require("auto-session.session-lens").search_session()
        end,
        desc = "Sessions",
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      local sessions = {
        action = 'lua require("auto-session.session-lens").search_session()',
        desc = " Sessions",
        icon = " ",
        key = "S",
      }

      sessions.desc = sessions.desc .. string.rep(" ", 43 - #sessions.desc)
      sessions.key_format = "  %s"

      table.insert(opts.config.center, 3, sessions)
    end,
  },
  -- Remote config - in noevide
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    opts = {
      client_callback = function(port, _)
        local cmd = ("neovide --server localhost:%s"):format(port)
        vim.fn.jobstart(cmd, {
          detach = true,
          on_exit = function(job_id, exit_code, event_type)
            -- This function will be called when the job exits
            print("Job", job_id, "exited with code", exit_code, "Event type:", event_type)
          end,
        })
      end,
    },
  },
  -- Toggle line blame
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
  -- Enable inlay hints by default
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      inlay_hints = {
        enabled = true,
      },
    },
  },
  -- Better terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = "<C-`>",
      insert_mappings = true,
      size = 25,
    },
  },
}
