-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.gruvbox-nvim" },
  { import = "astrocommunity.colorscheme.nordic-nvim" },
  { import = "astrocommunity.note-taking.neorg" },
  { import = "astrocommunity.git.git-blame-nvim" },
  {
    import = "astrocommunity.colorscheme.catppuccin",
    config = function()
      require("catppuccin").setup {
        no_italic = true,
      }
    end,
  },
  {
    import = "astrocommunity.colorscheme.kanagawa-nvim",
    config = function()
      require("kanagawa").setup {
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        keywordStyle = { italic = false },
        statementStyle = { bold = false },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        overrides = function(colors)
          return {
            -- Operator = { fg = colors.theme.syn.keyword, bold = false },
            ["@variable.builtin"] = { fg = colors.theme.syn.special2, italic = false },
            ["@keyword.operator"] = { fg = colors.palette.surimiOrange, bold = false },
            ["@string.escape"] = { fg = colors.theme.syn.regex, bold = false },
          }
        end,
      }
    end,
  },
  {
    import = "astrocommunity.editing-support.auto-save-nvim",
    config = function()
      require("auto-save").setup {
        debounce_delay = 1350000000, -- delay before auto-saving
      }
    end,
  },
}
