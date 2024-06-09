-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
  { "lunarvim/colorschemes" },  -- bling bling
  { "Yazeed1s/minimal.nvim" },  -- tomorrow night-ish
  { "Pocco81/auto-save.nvim" }, -- auto saving is not an option
}

lvim.colorscheme = 'tomorrow'  -- tomorrow night-ish
-- lvim.colorscheme = 'minimal-base16'  -- also pretty good looking

vim.opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = true -- wrap lines

lvim.builtin.which_key.mappings["e"] = { ":NvimTreeFocus<CR>", "Explorer" }
-- lvim.builtin.which_key.mappings["ec"] = { ":NvimTreeClose<CR>", "Explorer Close" }
