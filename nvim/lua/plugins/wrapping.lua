return {
  "andrewferrier/wrapping.nvim",
  event = "BufEnter *.*",
  config = function()
    require("wrapping").setup()
  end,
}
