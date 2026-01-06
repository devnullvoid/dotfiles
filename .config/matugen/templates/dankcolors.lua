return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		enabled = false,
		config = function()
			require("base16-colorscheme").setup({
				base00 = "#11111b",
				base01 = "#11111b",
				base02 = "#5c6370",
				base03 = "#5c6370",
				base04 = "#abb2bf",
				base05 = "#ffffff",
				base06 = "#ffffff",
				base07 = "#ffffff",
				base08 = "#e06c5f",
				base09 = "#e06c5f",
				base0A = "#e8c6ff",
				base0B = "#86e08d",
				base0C = "#9167ae",
				base0D = "#e8c6ff",
				base0E = "#8568c7",
				base0F = "#8568c7",
			})

			vim.api.nvim_set_hl(0, "Visual", {
				bg = "#5c6370",
				fg = "#ffffff",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "Statusline", {
				bg = "#e8c6ff",
				fg = "#11111b",
			})
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370" })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#9167ae", bold = true })

			vim.api.nvim_set_hl(0, "Statement", {
				fg = "#8568c7",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "Keyword", { link = "Statement" })
			vim.api.nvim_set_hl(0, "Repeat", { link = "Statement" })
			vim.api.nvim_set_hl(0, "Conditional", { link = "Statement" })

			vim.api.nvim_set_hl(0, "Function", {
				fg = "#e8c6ff",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "Macro", {
				fg = "#e8c6ff",
				italic = true,
			})
			vim.api.nvim_set_hl(0, "@function.macro", { link = "Macro" })

			vim.api.nvim_set_hl(0, "Type", {
				fg = "#9167ae",
				bold = true,
				italic = true,
			})
			vim.api.nvim_set_hl(0, "Structure", { link = "Type" })

			vim.api.nvim_set_hl(0, "String", {
				fg = "#86e08d",
				italic = true,
			})

			vim.api.nvim_set_hl(0, "Operator", { fg = "#abb2bf" })
			vim.api.nvim_set_hl(0, "Delimiter", { fg = "#abb2bf" })
			vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "Delimiter" })
			vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "Delimiter" })

			vim.api.nvim_set_hl(0, "Comment", {
				fg = "#5c6370",
				italic = true,
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(
					current_file_path,
					{},
					vim.schedule_wrap(function()
						local new_spec = dofile(current_file_path)
						if new_spec and new_spec[1] and new_spec[1].config then
							new_spec[1].config()
							print("Theme reload")
						end
					end)
				)
			end
		end,
	},
}
