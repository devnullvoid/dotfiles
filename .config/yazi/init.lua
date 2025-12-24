-- require("starship"):setup()
-- require("auto-layout")
require("sshfs").setup()
require("yaziline"):setup({
	separator_style = "angly",
	select_symbol = "",
	yank_symbol = "󰆐",
	separator_open = "",
	separator_close = "",
	separator_open_thin = "",
	separator_close_thin = "",
	-- separator_head = "",
	-- separator_tail = "",
})
require("full-border"):setup({
	type = ui.Border.ROUNDED,
})
function Linemode:size_and_mtime()
	local year = os.date("%Y")
	local time = (self._file.cha.mtime or 0) // 1

	if time > 0 and os.date("%Y", time) == year then
		time = os.date("%b %d %H:%M", time)
	else
		time = time and os.date("%b %d  %Y", time) or ""
	end

	local size = self._file:size()
	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or "-", time))
end
