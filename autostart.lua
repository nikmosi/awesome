local awful = require("awful")

local commands = {
	"setxkbmap -layout us,ru -option grp:alt_shift_toggle",
	"chatterino",
	"hyperhdr --desktop",
	"ayugram-desktop",
	"nekoray",
	"firefox",
	"easyeffects",
	"prismatik && sleep 0.5 && prismatik --on && prismatik --on",
}

for _, cmd in ipairs(commands) do
	awful.spawn.once(cmd, {})
end

return {}
