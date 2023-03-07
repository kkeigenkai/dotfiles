return {
  "nvim-neorg/neorg",
  commit = "36cc153",
  build = ":Neorg sync-parsers",
  event = "BufEnter *.*",
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.norg.concealer"] = {
        config = {
          icon_preset = "diamond",
        },
      },
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            notes = "~/notes",
            learning = "~/notes/learning/",
            work = "~/notes/work/",
            university = "~/notes/university",
          },
        },
      },
      ["core.export"] = {
        config = {
          export_dir = "~/notes/exp",
        },
      },
      ["core.export.markdown"] = {
        config = {
          extension = "md",
          extensions = "all",
        },
      },
    },
  },
  dependencies = { { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" } },
}
