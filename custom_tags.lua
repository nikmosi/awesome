local awful = require("awful")

-- Создать кастомный тег
awful.tag.add("web", {
	screen = awful.screen.focused(),
	layout = awful.layout.suit.tile,
	selected = true, -- открыть сразу при старте
})

-- Назначить хоткей на переключение
awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "w", function()
		local t = awful.tag.find_by_name(awful.screen.focused(), "web")
		if t then
			t:view_only()
		end
	end, { description = "переключиться на web", group = "tag" }),
})

-- Хоткей для перемещения окна на этот тег
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, "Shift" }, "w", function()
		if client.focus then
			local t = awful.tag.find_by_name(awful.screen.focused(), "web")
			if t then
				client.focus:move_to_tag(t)
			end
		end
	end, { description = "переместить окно на web", group = "tag" }),
})
return {}
