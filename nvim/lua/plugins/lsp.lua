local util = require("lspconfig/util")
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod", "norg" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      },
    },
  },
}
