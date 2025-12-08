return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local adapters = require("codecompanion.adapters")

      local function claude_code_adapter()
        return adapters.extend("claude_code", {
          env = {
            CLAUDE_CODE_OAUTH_TOKEN = "cmd:jq -r '.claudeAiOauth.accessToken' ~/.claude/.credentials.json",
          },
        })
      end

      local function gemini_cli_adapter()
        return adapters.extend("gemini_cli", {
          defaults = {
            auth_method = "oauth-personal",
          },
          env = {
            GEMINI_OAUTH_TOKEN = "cmd:jq -r '.access_token' ~/.gemini/oauth_creds.json",
          },
        })
      end

      local function codex_adapter()
        return adapters.extend("codex", {
          defaults = {
            auth_method = "chatgpt",
          },
          env = {
            CHATGPT_SESSION_TOKEN = "cmd:jq -r '.tokens.access_token' ~/.codex/auth.json",
          },
        })
      end

      local function zai_coding_adapter()
        return adapters.extend("openai", {
          env = {
            api_key = os.getenv("Z_API_KEY"),
            url = "https://api.z.ai/api/coding/paas/v4",
          },
          schema = {
            model = {
              default = "glm-4.6",
            },
          },
        })
      end

      require("codecompanion").setup({
        adapters = {
          claude_code = claude_code_adapter,
          gemini_cli = gemini_cli_adapter,
          codex = codex_adapter,
          zai_coding = zai_coding_adapter,
          acp = {
            claude_code = claude_code_adapter,
            gemini_cli = gemini_cli_adapter,
            codex = codex_adapter,
          },
          http = {
            zai_coding = zai_coding_adapter,
          },
        },
        strategies = {
          chat = {
            adapter = "claude_code",
          },
          inline = {
            adapter = "claude_code",
          },
        },
        opts = {
          log_level = "INFO",
        },
        ignore_warnings = true,
      })
    end,
  },
}
