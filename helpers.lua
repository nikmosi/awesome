local awful = require("awful")

local H = {}

function H.ensure_tag(name, scr)
	local s = scr or awful.screen.focused()
	local t = awful.tag.find_by_name(s, name)
	if not t then
		t = awful.tag.add(name, { screen = s, layout = awful.layout.suit.tile })
	end
	return t
end

function H.screen_by_index(idx)
	-- screen[1], screen[2], ...
	return screen[idx] or awful.screen.focused()
end

return H
