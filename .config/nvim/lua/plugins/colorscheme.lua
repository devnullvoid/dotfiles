return {
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   priority = 1001,
  --   config = function()
  --     -- Ensure the colorscheme is applied after the plugin loads.
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
