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
      require("codecompanion").setup({
        adapters = {
          acp = {
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                env = {
                  CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
                },
              })
            end,
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
      })
    end,
  },
}
