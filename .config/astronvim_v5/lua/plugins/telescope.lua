-- lua/plugins/telescope.lua
vim.notify("Loading custom telescope config", vim.log.levels.INFO)

return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    vim.notify("Merging custom telescope config with hidden files", vim.log.levels.INFO)
    
    -- Ensure defaults table exists
    opts.defaults = opts.defaults or {}
    
    -- Override vimgrep_arguments completely
    opts.defaults.vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename", 
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden", -- include hidden files
      "--glob",
      "!.git/*", -- but still ignore .git
    }
    
    -- Ensure pickers table exists
    opts.pickers = opts.pickers or {}
    opts.pickers.find_files = opts.pickers.find_files or {}
    opts.pickers.find_files.hidden = true
    
    vim.notify("Final vimgrep_arguments: " .. vim.inspect(opts.defaults.vimgrep_arguments), vim.log.levels.INFO)
    
    return opts
  end,
}
