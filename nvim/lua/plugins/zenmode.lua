return {
  "folke/zen-mode.nvim",
  event = "BufEnter *.*",
  keys = {
    {
      mode = { "n" },
      "<leader>tz",
      "<cmd>ZenMode<cr>",
      desc = "Toggle ZenMode",
    },
  },
  opts = {
    window = {
      backdrop = 1,
      width = 120, -- width of the Zen window
      height = 1, -- height of the Zen window
      options = {
        -- signcolumn = "no", -- disable signcolumn
        number = false, -- disable number column
        relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        -- cursorcolumn = false, -- disable cursor column
        -- foldcolumn = "0", -- disable fold column
        -- list = false, -- disable whitespace characters
      },
    },
    on_open = function()
      if vim.g.neovide then
        vim.o.guifont = "Iosevka Custom:h18"
      end
    end,
    -- callback where you can add custom code when the Zen window closes
    on_close = function()
      if vim.g.neovide then
        vim.o.guifont = "Iosevka Custom:h14"
      end
    end,
  },
}
