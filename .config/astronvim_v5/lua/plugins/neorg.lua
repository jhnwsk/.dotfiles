-- lua/plugins/neorg.lua
return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "norg",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Load all the default modules
          ["core.concealer"] = {}, -- Pretty icons
          ["core.dirman"] = { -- Manage Neorg workspaces
            config = {
              workspaces = {
                notes = "~/neorg/notes",
              },
              default_workspace = "notes",
            },
          },
        },
      }
    end,
  },
}
