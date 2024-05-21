-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = ""

-- Disable auto-format on save
vim.g.autoformat = false

-- Neovide related options
vim.g.neovide_scroll_animation_length = 0.06
vim.g.neovide_cursor_animation_length = 0.03
vim.g.neovide_cursor_trail_size = 0.2
vim.g.neovide_input_macos_option_key_is_meta = true
