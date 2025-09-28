local awful = require("awful")

-- общий пресет для всех окон, созданных этими спавнами
local DEFAULT = {
	floating = false,
	focus = false,
	switch_to_tags = false,
	honor_padding = true,
	honor_workarea = true,
}

local function merge(a, b)
	local r = {}
	for k, v in pairs(a or {}) do
		r[k] = v
	end
	for k, v in pairs(b or {}) do
		r[k] = v
	end
	return r
end

-- список приложений: команда + частные свойства
local APPS = {
	{ -- раскладка, окна нет: свойства не важны
		cmd = "setxkbmap -layout us,ru -option grp:alt_shift_toggle",
		props = {},
		shell = false,
	},
	{
		cmd = "chatterino",
		props = {
			urgent = false,
			floating = false,
		},
	},
	{
		cmd = "hyperhdr --desktop",
		props = {
			floating = true,
			minimized = true,
		},
	},
	{
		cmd = "ayugram-desktop",
		props = {
			urgent = false,
			floating = false,
		},
	},
	{
		cmd = "nekoray",
		props = {
			floating = true,
			urgent = false,
		},
	},
	{
		cmd = "firefox",
		props = {
			floating = false,
		},
	},
	{
		cmd = "easyeffects",
		props = {
			urgent = false,
			floating = true,
			minimized = true,
			ontop = false,
		},
	},
}

-- запуск
for _, app in ipairs(APPS) do
	local props = merge(DEFAULT, app.props)
	if app.shell then
		awful.spawn.with_shell(app.cmd, props) -- свойства пойдут через DESKTOP_STARTUP_ID
	else
		awful.spawn(app.cmd, props)
	end
end

return {}
