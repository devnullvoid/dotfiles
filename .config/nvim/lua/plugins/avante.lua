return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "claude", -- Default provider
      acp_providers = {
        ["claude-code"] = {
          command = "npx",
          args = { "@zed-industries/claude-code-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            -- ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
            -- CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
          },
        },
        ["gemini-cli"] = {
          command = "gemini",
          args = { "--experimental-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            -- GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
          },
        },
        ["codex"] = {
          command = "npx",
          args = { "@zed-industries/codex-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            -- OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
          },
        },
      },
    },
  },
}
