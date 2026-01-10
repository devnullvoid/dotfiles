return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		enabled = false,
		lazy = false,
		config = function()
			vim.o.termguicolors = true

			require("base16-colorscheme").setup({
				base00 = "#1e1e2e",
				base01 = "#181825",
				base02 = "#313244",
				base03 = "#45475a",
				base04 = "#585b70",
				base05 = "#cdd6f4",
				base06 = "#f5e0dc",
				base07 = "#b4befe",
				base08 = "#f38ba8",
				base09 = "#fab387",
				base0A = "#f9e2af",
				base0B = "#a6e3a1",
				base0C = "#94e2d5",
				base0D = "#89b4fa",
				base0E = "#cba6f7",
				base0F = "#eba0ac",
			})

			vim.g.colors_name = "dankcolors"

			vim.api.nvim_set_hl(0, "Visual", {
				bg = "#45475a",
				fg = "#cdd6f4",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "Statusline", {
				bg = "#b4befe",
				fg = "#1e1e2e",
			})
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#585b70" })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#cba6f7", bold = true })

			vim.api.nvim_set_hl(0, "Statement", {
				fg = "#cba6f7",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "Keyword", { link = "Statement" })
			vim.api.nvim_set_hl(0, "Repeat", { link = "Statement" })
			vim.api.nvim_set_hl(0, "Conditional", { link = "Statement" })

			vim.api.nvim_set_hl(0, "Function", {
				fg = "#89b4fa",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "Macro", {
				fg = "#b4befe",
				italic = true,
			})
			vim.api.nvim_set_hl(0, "@function.macro", { link = "Macro" })

			vim.api.nvim_set_hl(0, "Type", {
				fg = "#94e2d5",
				bold = true,
				italic = true,
			})
			vim.api.nvim_set_hl(0, "Structure", { link = "Type" })

			vim.api.nvim_set_hl(0, "String", {
				fg = "#a6e3a1",
				italic = true,
			})

			vim.api.nvim_set_hl(0, "Operator", { fg = "#cdd6f4" })
			vim.api.nvim_set_hl(0, "Delimiter", { fg = "#cdd6f4" })
			vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "Delimiter" })
			vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "Delimiter" })

			vim.api.nvim_set_hl(0, "Comment", {
				fg = "#585b70",
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
