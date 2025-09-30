local function gemini_cli_adapter()
  local adapters = require("codecompanion.adapters")
  local overrides = {}

  if vim.env.GEMINI_API_KEY and vim.env.GEMINI_API_KEY ~= "" then
    overrides.defaults = {
      auth_method = "gemini-api-key",
    }

  end

  return adapters.extend("gemini_cli", overrides)
end

local function claude_adapter()
  local adapters = require("codecompanion.adapters")
  local overrides = {}

  if vim.env.ANTHROPIC_API_KEY and vim.env.ANTHROPIC_API_KEY ~= "" then
    overrides.defaults = {
      auth_method = "anthropic-api-key",
    }
  end

  return adapters.extend("anthropic", overrides)
end

local M = {
  adapters = {
    acp = {
      gemini_cli = gemini_cli_adapter,
      claude = claude_adapter,
    },
  },
  strategies = {
    chat = {
      adapter = "claude",
    },
    inline = {
      adapter = "claude",
    },
  },
  opts = {
    log_level = "INFO",
  },
}

return M

