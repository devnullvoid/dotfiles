-- require("starship"):setup()
-- require("auto-layout")
require("yaziline"):setup({
  separator_style = "curvy",
  select_symbol = "",
  yank_symbol = "󰆐",
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
