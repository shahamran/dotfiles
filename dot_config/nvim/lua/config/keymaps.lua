-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>gg", function()
  LazyVim.lazygit()
end, { desc = "Lazygit (cwd)" })
map("n", "<leader>gG", function()
  LazyVim.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "Lazygit (Root Dir)" })
map("n", "<C-w>0", "<C-w>25_", { desc = "Set width to 25" })

-- Neovide related keymaps
if vim.g.neovide then
  map("v", "<D-c>", '"+y', { desc = "Copy to clipboard (neovide)" })
  map({ "n", "v" }, "<D-v>", '"+P', { desc = "Paste from clipboard (neovide)" })
  map({ "i", "c" }, "<D-v>", "<C-R>+", { desc = "Paste from clipboard (neovide)" })
  map("t", "<D-v>", [[<C-\><C-N>"+Pi]], { desc = "Paste from clipboard (neovide)" })

  map({ "n", "i", "t", "v", "c" }, "<D-Left>", "<Home>", { desc = "Home", silent = true })
  map({ "n", "i", "t", "v", "c" }, "<D-Right>", "<End>", { desc = "End", silent = true })

  map({ "n", "i" }, "<D-=>", function()
    vim.g.neovide_scale_factor = math.min(vim.g.neovide_scale_factor + 0.1, 3.0)
  end, {
    desc = "Increase scale factor (neovide)",
    silent = true,
  })
  map({ "n", "i" }, "<D-->", function()
    vim.g.neovide_scale_factor = math.max(vim.g.neovide_scale_factor - 0.1, 0.2)
  end, {
    desc = "Decrease scale factor (neovide)",
    silent = true,
  })
  map({ "n", "i" }, "<D-0>", function()
    vim.g.neovide_scale_factor = 1
  end, {
    desc = "Reset scale factor (neovide)",
    silent = true,
  })
end
