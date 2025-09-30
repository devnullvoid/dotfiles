-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local has_lspconfig, lspconfig = pcall(require, "lspconfig")
local mason_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local nvlsp = require "nvchad.configs.lspconfig"

local navic_ok, navic = pcall(require, "nvim-navic")

local function on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)

  if navic_ok and client.supports_method "textDocument/documentSymbol" then
    navic.attach(client, bufnr)
    vim.api.nvim_exec_autocmds("User", {
      pattern = "NavicAttach",
      modeline = false,
      data = { bufnr = bufnr, client = client },
    })
  end
end

local lua_workspace = {
  vim.fn.expand "$VIMRUNTIME/lua",
  vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
  vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
  vim.fn.stdpath "config" .. "/lua",
}

local server_settings = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = lua_workspace,
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
}

local function setup(server)
  local opts = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }, server_settings[server] or {})

  if vim.lsp and vim.lsp.config then
    local ok = pcall(vim.lsp.config, server, opts)
    if ok then
      if vim.lsp.enable then
        pcall(vim.lsp.enable, server)
      end
      return
    end
  end

  if has_lspconfig and lspconfig[server] then
    lspconfig[server].setup(opts)
  else
    vim.notify(
      string.format("[lsp] skipped setup for %s (not supported by current LSP config)", server),
      vim.log.levels.WARN
    )
  end
end

local installed = {}

if mason_ok then
  mason_lspconfig.setup {
    automatic_installation = true,
  }

  if mason_lspconfig.get_installed_servers then
    installed = mason_lspconfig.get_installed_servers()
  end

  if mason_lspconfig.setup_handlers then
    mason_lspconfig.setup_handlers {
      function(server)
        setup(server)
      end,
    }
  else
    for _, server in ipairs(installed) do
      setup(server)
    end
  end
end

local fallback_servers = { "lua_ls", "html", "cssls" }
for _, server in ipairs(fallback_servers) do
  if not mason_ok or not vim.tbl_contains(installed, server) then
    setup(server)
  end
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
