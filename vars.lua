local M = {}

local gears = require("gears")
local awful = require("awful")
local modkey = "Mod4"

local conf_dir = gears.filesystem.get_configuration_dir()

M.modkey = modkey

M.wallpappers = {
	conf_dir .. "themes/1.jpg",
	conf_dir .. "themes/2.jpg",
}

local map = {
	["0"] = "〇",
	["1"] = "一",
	["2"] = "二",
	["3"] = "三",
	["4"] = "四",
	["5"] = "五",
	["6"] = "六",
	["7"] = "七",
	["8"] = "八",
	["9"] = "九",
}

local function to_japanese(tbl)
	local result = {}
	for i, v in ipairs(tbl) do
		local s = tostring(v)
		local converted = s:gsub("%d", map)
		result[i] = converted
	end
	return result
end

M.tags = {
	web = "🌐",
	discord = "の",
	chatterino = "chat",
	minecraft = "mine",
	easyeffects = "ee",
	for_each_screen = to_japanese({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }),
}
-- какие экраны использовать (1 = левый/первый, 2 = правый/второй)
M.affinity = {
	web = 1,
	minecraft = 1,
	discord = 2,
	chatterino = 2,
	easyeffects = 2,
}

M.clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

M.clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

return M
