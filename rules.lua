local vars = require("vars")

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library

awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = vars.clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },

	-- firefox -> 🌐 на экран 1
	{
		rule = { class = "firefox" },
		properties = { tag = vars.tags.web, switchtotag = true },
	},

	-- easyeffects -> свой тег на экран 2
	{
		rule = { class = "easyeffects" },
		properties = { screen = 2, tag = "2", switchtotag = false },
	},

	-- discord-семейство -> の на экран 2
	{
		rule_any = {
			class = {
				"anilibrix",
				"discord",
				"legcord",
				"hiddify",
				"ayugram-desktop",
				"telegram-desktop",
				"vesktop",
			},
		},
		properties = { screen = 2, tag = "4", switchtotag = false },
	},

	-- chatterino -> 󰕃 на экран 2
	{
		rule = { class = "chatterino" },
		properties = { screen = 2, tag = "6", switchtotag = false },
	},

	-- minecraft и лончеры ->  на экран 1
	{
		rule_any = {
			name = { "^Minecraft" }, -- Lua-паттерн, начало строки
			class = { "steam_proton", "epicgameslauncher.exe", "rocketleague.exe", "bakkesmod.exe" },
		},
		properties = { tag = "6", switchtotag = false },
	},
	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},

			class = {
				"pavucontrol",
				"qbittorrent",
				"float_pass",
				"ripdrag",
				"ssh-askpass",
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"branchdialog",
				"pinentry",
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

return {}
