return {
  {
    "akinsho/bufferline.nvim",
    dependencies = { "catppuccin" },
    opts = {
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
    },
  },
}
