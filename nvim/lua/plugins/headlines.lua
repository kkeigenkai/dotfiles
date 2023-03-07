return {
  "lukas-reineke/headlines.nvim",
  enabled = false,
  event = "BufEnter *.norg",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    norg = {
      headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
      codeblock_highlight = { "NeorgCodeBlock" },
    },
  },
}
