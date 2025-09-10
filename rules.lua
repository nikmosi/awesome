local awful = require("awful")
local vars = require("vars")
local H = require("helpers")

local function to_tag(name, idx, also_view)
	return function(c)
		local s = H.screen_by_index(idx)
		local t = H.ensure_tag(name, s)
		c:move_to_tag(t)
		if also_view then
			t:view_only()
		end
	end
end

awful.rules.rules = {
	-- базовые
	{
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
		},
	},
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },

	-- плавающие
	{
		rule_any = {
			class = { "pavucontrol", "qbittorrent", "float_pass", "ripdrag", "ssh-askpass" },
			name = { "branchdialog", "pinentry" },
		},
		properties = { floating = true },
	},

	-- firefox -> 🌐 на экран 1
	{
		rule = { class = "firefox" },
		properties = { switchtotag = false },
		callback = to_tag(vars.tags.web, vars.affinity.web),
	},

	-- easyeffects -> свой тег на экран 2
	{
		rule = { class = "easyeffects" },
		properties = { switchtotag = false },
		callback = to_tag(vars.tags.easyeffects, vars.affinity.easyeffects),
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
		properties = { switchtotag = false },
		callback = to_tag(vars.tags.discord, vars.affinity.discord),
	},

	-- chatterino -> 󰕃 на экран 2
	{
		rule = { class = "chatterino" },
		properties = { switchtotag = false },
		callback = to_tag(vars.tags.chatterino, vars.affinity.chatterino),
	},

	-- minecraft и лончеры ->  на экран 1
	{
		rule_any = {
			name = { "^Minecraft" }, -- Lua-паттерн, начало строки
			class = { "steam_proton", "epicgameslauncher.exe", "rocketleague.exe", "bakkesmod.exe" },
		},
		properties = { switchtotag = false },
		callback = to_tag(vars.tags.minecraft, vars.affinity.minecraft),
	},
}

return {}
