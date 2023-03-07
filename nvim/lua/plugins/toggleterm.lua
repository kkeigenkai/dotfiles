return {
  "akinsho/toggleterm.nvim",
  keys = {
    {
      mode = { "n", "t" },
      "<leader>\\",
      "<cmd>ToggleTerm dir=./ direction=float<cr>",
      desc = "toogle term",
    },
  },
  opts = function()
    return {
      shell = "fish",
    }
  end,
}
