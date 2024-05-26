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
  -- Remote config - in noevide
  -- {
  --   "amitds1997/remote-nvim.nvim",
  --   version = "*", -- Pin to GitHub releases
  --   opts = {
  --     client_callback = function(port, _)
  --       local cmd = ("neovide --server localhost:%s"):format(port)
  --       vim.fn.jobstart(cmd, {
  --         detach = true,
  --         on_exit = function(job_id, exit_code, event_type)
  --           -- This function will be called when the job exits
  --           print("Job", job_id, "exited with code", exit_code, "Event type:", event_type)
  --         end,
  --       })
  --     end,
  --   },
  -- },
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
  -- Documentation generation
  {
    "danymat/neogen",
    config = true,
  },

  -- Highlights in chezmoi source dir
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },
}
