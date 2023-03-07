return {
  "nvim-treesitter/nvim-treesitter",
  opts = function()
    require("nvim-treesitter.install").compilers = { "gcc" }
  end,
}
