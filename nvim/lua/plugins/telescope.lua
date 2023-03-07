return {
  "nvim-telescope/telescope.nvim",
  event = "BufEnter",
  keys = {
    {
      mode = { "n" },
      "<leader>fp",
      "<cmd>Telescope project<cr>",
      desc = "List projects",
    },
  },
  config = function()
    require("telescope").load_extension("project")
    return {
      extensions = {
        project = {
          base_dirs = {
            "~/.config",
            "~/Developer",
          },
          hidden_files = true, -- default: false
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          sync_with_nvim_tree = true, -- default false
        },
      },
    }
  end,
}
