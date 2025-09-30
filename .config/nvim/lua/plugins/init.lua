return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  -- The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config (see :help lspconfig-nvim-0.11) instead.                    
-- Feature will be removed in nvim-lspconfig v3.0.0
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { import = "nvchad.blink.lazyspec" },

  {
    "Saghen/blink.cmp",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "copilot" },
          per_filetype = {
            codecompanion = { "codecompanion" },
          },
          providers = {
            copilot = {
              name = "Copilot",
              module = "blink-cmp-copilot",
              score_offset = 100,
              async = true,
            },
          },
        },
        completion = {
          list = {
            selection = {
              preselect = false,
            },
          },
        },
        cmdline = {
          completion = {
            list = {
              selection = {
                preselect = false,
              },
            },
          },
        },
      })
    end,
  },

  {
      "kylechui/nvim-surround",
      version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  {
    "giuxtaposition/blink-cmp-copilot",
    dependencies = {
      "Saghen/blink.cmp",
      "zbirenbaum/copilot.lua",
    },
  },

  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    opts = require("configs.codecompanion"),
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      "stevearc/dressing.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
      }
  },

  {
    "nvim-mini/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("configs.mini")
    end,
  },

  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      highlight = true,
      separator = " ⋅ ",
    },
    config = function(_, opts)
      require("configs.navic").setup(opts)
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason-org/mason.nvim",
    opts = {
      automatic_installation = true,
    },
  },

  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup(require "configs.lspsaga")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      separator = ".",  -- looks like a dashed rule with many themes
      -- max_lines = 2,
      -- trim_scope = "inner",
    },
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
