local gears = require("gears")
local awful = require("awful")

local web = require("vars").tags.web

-- тег
awful.tag.add(web, {
	screen = awful.screen.focused(),
	layout = awful.layout.suit.tile,
	selected = true,
})

-- глобальные хоткеи
local globalkeys = root.keys()
globalkeys = gears.table.join(
	globalkeys,

	awful.key({ modkey }, "w", function()
		local t = awful.tag.find_by_name(awful.screen.focused(), web)
		if t then
			t:view_only()
		end
	end, { description = "toggle to " .. web, group = "tag" }),

	awful.key({ modkey, "Shift" }, "w", function()
		local c = client.focus
		if not c then
			return
		end
		local t = awful.tag.find_by_name(c.screen, web)
		if t then
			c:move_to_tag(t)
		end
	end, { description = "toogle to " .. web, group = "tag" })
)
root.keys(globalkeys)
