return {
  {
    "yetone/avante.nvim",
    priority = 49,
    opts = function(_, opts)
      opts.provider = "codex"
      opts.acp_providers = vim.tbl_deep_extend("force", opts.acp_providers or {}, {
        ["claude-code"] = {
          command = "npx",
          args = { "@zed-industries/claude-code-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            CLAUDE_CODE_OAUTH_TOKEN = "cmd:jq -r '.claudeAiOauth.accessToken' ~/.claude/.credentials.json",
          },
        },
        ["gemini-cli"] = {
          command = "gemini",
          args = { "--experimental-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            GEMINI_OAUTH_TOKEN = "cmd:jq -r '.access_token' ~/.gemini/oauth_creds.json",
          },
        },
        ["codex"] = {
          command = "npx",
          args = { "@zed-industries/codex-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            CHATGPT_SESSION_TOKEN = "cmd:jq -r '.tokens.access_token' ~/.codex/auth.json",
          },
        },
      })

      opts.providers = vim.tbl_deep_extend("force", opts.providers or {}, {
        ["zai-coding"] = {
          __inherited_from = "openai",
          endpoint = "https://api.z.ai/api/coding/paas/v4",
          api_key_name = "Z_API_KEY",
          model = "glm-4.6",
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "Kaiser-Yang/blink-cmp-avante" },
    opts = function(_, opts)
      local function is_avante_buffer()
        local ft = vim.bo.filetype
        return ft == "AvanteInput" or ft == "AvantePromptInput"
      end

      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.avante = vim.tbl_deep_extend("force", {
        module = "blink-cmp-avante",
        name = "Avante",
        opts = {
          avante = {
            command = { enable = is_avante_buffer },
            mention = { enable = is_avante_buffer },
            shortcut = { enable = is_avante_buffer },
          },
        },
      }, opts.sources.providers.avante or {})

      opts.sources.default = opts.sources.default or {}
      if type(opts.sources.default) == "table" and not vim.tbl_contains(opts.sources.default, "avante") then
        table.insert(opts.sources.default, "avante")
      end
    end,
  },
}
