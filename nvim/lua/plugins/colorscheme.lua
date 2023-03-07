return {
  {
    "ellisonleao/gruvbox.nvim",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      no_bold = false,
      no_italic = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = { "bold" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
    },
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github",
    tag = "v0.0.7",
  },
  {
    "NTBBloodbath/doom-one.nvim",
    name = "doom-one",
  },
  {
    "AlexvZyl/nordic.nvim",
    name = "nordic",
    config = function()
      require("nordic").setup({
        -- Available themes: 'nordic', 'onedark'.
        -- Onedark is WIP.
        theme = "onedark",
        -- Enable bold keywords.
        bold_keywords = true,
        -- Enable italic comments.
        italic_comments = true,
        -- Enable general editor background transparency.
        transparent_bg = false,
        -- Nordic specific options.
        -- Set all to false to use original Nord colors.
        -- Adjusts some colors to make the theme a bit nicer (imo).
        nordic = {
          -- Reduce the overall amount of blue in the theme (diverges from base Nord).
          reduced_blue = true,
        },
        -- Onedark specific options.
        -- Set all to false to keep original onedark colors.
        -- Adjusts some colors to make the theme a bit nicer (imo).
        -- WIP.
        onedark = {
          -- Brighten the whites to fit the theme better.
          brighter_whites = true,
        },
        -- Override the styling of any highlight group.
        override = {},
        cursorline = {
          -- Enable bold font in cursorline.
          bold = false,
          -- Avialable styles: 'dark', 'light'.
          theme = "dark",
          -- Hide the cursorline when the window is not focused.
          hide_unfocused = true,
        },
        noice = {
          -- Available styles: `classic`, `flat`.
          style = "flat",
        },
        telescope = {
          -- Available styles: `classic`, `flat`.
          style = "flat",
        },
        leap = {
          -- Dims the backdrop when using leap.
          dim_backdrop = false,
        },
      })
    end,
  },
}
