return {
  {
    "catppuccin/nvim",
    lazy = true,
    version = "*",
    name = "catppuccin",
    opts = {
      transparent_background = false,
      dim_inactive = {
        enabled = true,
      },
      integrations = {
        dap = {
          enabled = true,
          enable_ui = true,
        },
        illuminate = true,
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = {
          enabled = true,
        },
        neotree = true,
        noice = true,
        notify = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
}
