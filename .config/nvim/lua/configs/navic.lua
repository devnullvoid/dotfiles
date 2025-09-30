local M = {}

function M.setup(opts)
  local navic = require "nvim-navic"
  navic.setup(opts or {})
end

return M
