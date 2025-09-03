-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
  -- {
  --   "rebelot/kanagawa.nvim",
  --   config = function()
  --     require("kanagawa").setup {
  --       undercurl = true, -- enable undercurls
  --       commentStyle = { italic = false },
  --       keywordStyle = { italic = false },
  --       statementStyle = { italic = false, bold = false },
  --       typeStyle = {},
  --       transparent = false, -- do not set background color
  --       dimInactive = false, -- dim inactive window `:h hl-NormalNC`
  --       terminalColors = true, -- define vim.g.terminal_color_{0,17}
  --       overrides = function(colors)
  --         return {
  --           ["@variable.builtin"] = { fg = colors.theme.syn.special2, italic = false },
  --           ["@keyword.operator"] = { fg = colors.palette.surimiOrange, bold = false },
  --           ["@string.escape"] = { fg = colors.theme.syn.regex, bold = false },
  --         }
  --       end,
  --     }
  --   end,
  -- },
  {
    "Pocco81/auto-save.nvim",
    event = { "User AstroFile", "InsertEnter" },
    opts = {
      debounce_delay = 3000, -- delay before auto-saving, 3 seconds?
      trigger_events = { "BufLeave" }, -- vim events that trigger auto-save. See :h events
      callbacks = {
        before_saving = function()
          -- save global autoformat status
          vim.g.OLD_AUTOFORMAT = vim.g.autoformat_enabled

          vim.g.autoformat_enabled = false
          vim.g.OLD_AUTOFORMAT_BUFFERS = {}
          -- disable all manually enabled buffers
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.b[bufnr].autoformat_enabled then
              table.insert(vim.g.OLD_BUFFER_AUTOFORMATS, bufnr)
              vim.b[bufnr].autoformat_enabled = false
            end
          end
        end,
        after_saving = function()
          -- restore global autoformat status
          vim.g.autoformat_enabled = vim.g.OLD_AUTOFORMAT
          -- reenable all manually enabled buffers
          for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
            vim.b[bufnr].autoformat_enabled = true
          end
        end,
      },
    },
  },

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- Custom catppuccin-tomorrow colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin-tomorrow",
    opts = function()
      -- Tomorrow Night color palette
      local tomorrow_colors = {
        base = "#1D1F21",     -- background
        mantle = "#1D1F21",   -- slightly darker bg
        crust = "#1A1C1E",    -- darkest bg
        text = "#C5C8C6",     -- foreground
        subtext1 = "#B4B7B4", -- slightly dimmed text
        subtext0 = "#A3A6A3", -- more dimmed text
        overlay2 = "#8C8F8C", -- overlay colors
        overlay1 = "#6C6F6C",
        overlay0 = "#4C4F4C",
        surface2 = "#3C3F3C",
        surface1 = "#2C2F2C",
        surface0 = "#1D1F21",
        -- Tomorrow Night accent colors
        red = "#CC6666",
        maroon = "#B85450",
        peach = "#DE935F",
        yellow = "#F0C674",
        green = "#B5BD68",
        teal = "#8ABEB7",
        sky = "#7ABCF7",
        sapphire = "#74C7EC",
        blue = "#81A2BE",
        lavender = "#B4BEFE",
        mauve = "#B294BB",
        pink = "#F5C2E7",
        flamingo = "#F2CDCD",
        rosewater = "#F5E0DC",
      }

      return {
        flavor = "mocha",
        color_overrides = {
          mocha = tomorrow_colors,
        },
        custom_highlights = function(c)
          return {
            Comment = { fg = c.overlay1, style = { "italic" } },
            CursorLine = { bg = c.surface0 },
            Visual = { bg = c.surface1 },
            Folded = { bg = c.surface0, fg = c.overlay1 },
            Normal = { bg = c.base, fg = c.text },
            NormalNC = { bg = c.base, fg = c.text },
          }
        end,
      }
    end,
    config = function(_, opts)
      -- Create a command to switch to catppuccin-tomorrow
      vim.api.nvim_create_user_command("CatppuccinTomorrow", function()
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
      end, { desc = "Switch to catppuccin with Tomorrow Night colors" })
      
      -- Auto-apply catppuccin-tomorrow after startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(function()
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
          end)
        end,
      })
    end,
  },


  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
