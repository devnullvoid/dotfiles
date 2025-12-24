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
          model = "glm-4.7",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.7,
            -- max_tokens = 4096,
          },
        },
        ["kimi-coding"] = {
          __inherited_from = "openai",
          endpoint = "https://api.kimi.com/coding/v1",
          api_key_name = "KIMI_API_KEY",
          model = "kimi-for-coding",
          timeout = 30000,
          use_xml_format = false,
          max_tokens = 32768,
          extra_request_body = {
            stream = true,
            reasoning_effort = "medium",
          },
        },
      })

      -- Windows and display configuration
      opts.windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
        input = {
          prefix = "> ",
          height = 8,
        },
        edit = {
          border = "rounded",
          start_insert = true,
        },
        ask = {
          floating = false,
          start_insert = true,
          border = "rounded",
          focus_on_apply = "ours",
        },
      }

      -- Behavior settings
      opts.behaviour = {
        auto_suggestions = false,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        minimize_diff = true,
        auto_add_current_file = true,
      }

      -- Keymaps
      opts.mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        toggle = {
          default = "<leader>at",
          debug = "<leader>ad",
          hint = "<leader>ah",
          suggestion = "<leader>as",
        },
        sidebar = {
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      }

      -- Diff configuration
      opts.diff = {
        autojump = true,
        list_opener = "copen",
        override_timeoutlen = 500,
      }

      -- Selection and hints
      opts.selection = {
        enabled = true,
        hint_display = "delayed",
      }
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
