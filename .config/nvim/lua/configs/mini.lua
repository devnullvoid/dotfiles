local present, indentscope = pcall(require, "mini.indentscope")

if present then
  indentscope.setup({
    -- draw = {
    --   animation = indentscope.gen_animation.none(),
    -- },
    -- symbol = "|", -- "│", "󰇙",
    options = {
      try_as_border = true,
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Disable Mini Indentscope on special buffers",
    pattern = {
      "help",
      "lazy",
      "mason",
      "NvimTree",
      "Trouble",
      "alpha",
      "dashboard",
      "neo-tree",
      "lir",
      "toggleterm",
    },
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
end

return true
