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
          defaults = {
            auth_method = "oauth",
          },
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
            OPENAI_API_KEY = "cmd:jq -r '.tokens.access_token' ~/.codex/auth.json",
          },
        })
      end

      local function zai_coding_adapter()
        return adapters.extend("openai", {
          env = {
            api_key = "cmd:echo $Z_API_KEY",
            url = "https://api.z.ai/api/coding/paas/v4",
          },
          schema = {
            model = {
              default = "glm-4.7",
            },
          },
        })
      end

      local function kimi_coding_adapter()
        return adapters.extend("openai", {
          env = {
            api_key = "cmd:echo $KIMI_API_KEY",
            url = "https://api.kimi.com/coding/v1",
          },
          schema = {
            model = {
              default = "kimi-for-coding",
            },
            max_tokens = {
              default = 32768,
            },
            temperature = {
              default = 0.7,
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
          kimi_coding = kimi_coding_adapter,
          acp = {
            claude_code = claude_code_adapter,
            codex = codex_adapter,
            gemini_cli = gemini_cli_adapter,
          },
          http = {
            zai_coding = zai_coding_adapter,
            kimi_coding = kimi_coding_adapter,
            opts = {
              allow_insecure = false,
              cache_models_for = 1800, -- Cache for 30 minutes
            },
          },
        },
        strategies = {
          chat = {
            adapter = "claude_code",
            roles = {
              llm = "AI Assistant",
              user = "Jon",
            },
            keymaps = {
              send = { modes = { n = "<CR>", i = "<C-s>" } },
              close = { modes = { n = "q", i = "<C-c>" } },
              stop = { modes = { n = "<C-q>" } },
              regenerate = { modes = { n = "gr" } },
            },
            tools = {
              cmd_runner = {
                opts = { requires_approval = true },
              },
              insert_edit_into_file = {
                opts = {
                  requires_approval = { buffer = false, file = false },
                  user_confirmation = true,
                },
              },
            },
          },
          inline = {
            adapter = "zai_coding",
          },
        },
        display = {
          chat = {
            window = {
              layout = "vertical",
              width = 0.4,
              height = 0.8,
              border = "rounded",
            },
            show_settings = true,
            show_token_count = true,
            intro_message = "Welcome! How can I help?",
          },
          diff = {
            provider = "inline",
          },
          action_palette = {
            provider = "telescope",
          },
        },
        prompt_library = {
          ["Explain Code"] = {
            strategy = "chat",
            description = "Explain selected code",
            opts = { short_name = "explain", auto_submit = true },
            prompts = {
              { role = "system", content = "Explain code clearly and concisely." },
              {
                role = "user",
                content = function(context)
                  return "Explain:\n\n```" .. context.filetype .. "\n" .. table.concat(context.lines, "\n") .. "\n```"
                end,
              },
            },
          },
          ["Optimize"] = {
            strategy = "inline",
            description = "Optimize selected code",
            opts = { short_name = "optimize" },
            prompts = {
              { role = "system", content = "Optimize code for performance and readability." },
            },
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
