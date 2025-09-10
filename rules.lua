local awful = require("awful")

awful.rules.rules = {
	{
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
		},
	},
	{
		rule = { class = "firefox" },
		properties = {
			-- автоматически на тег "web"
			tag = require("vars").web,
			switchtotag = false, -- сразу переключаться на него
		},
	},
	{
		rule_any = {
			type = { "normal", "dialog" },
		},
		properties = { titlebars_enabled = false },
	},
	{
		rule_any = {
			class = {
				"pavucontrol",
				"qbittorrent",
				"float_pass",
				"ripdrag",
				"ssh-askpass",
			},
			name = {
				"branchdialog",
				"pinentry",
			},
		},
		properties = { floating = true },
	},
}

return {}
