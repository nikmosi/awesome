-- ~/.config/awesome/screenshot.lua
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

local M = {}

-- === конфиг ===
local HOME = os.getenv("HOME") or ""
local conf = {
	home = HOME,
	xclip_image = "xclip -selection clipboard -t image/png -i %q",
	xclip_text = "printf %q | xclip -selection clipboard",
	imgur = {
		url = "https://example.com/upload", -- замени на свой endpoint
	},
}

-- === утилиты ===
local function notify(title, text, level)
	naughty.notify({ title = title, text = text, preset = naughty.config.presets[level or "normal"] })
end

local function sh(cmd, cb)
	awful.spawn.easy_async_with_shell(cmd, function(out, err, reason, code)
		if cb then
			cb(out, err, code)
		end
	end)
end

local function sh_sync(cmd)
	local f = io.popen(cmd .. " 2>/dev/null")
	if not f then
		return nil
	end
	local out = f:read("*a")
	f:close()
	return out
end

local function ensure_dir(path)
	sh_sync(string.format("mkdir -p %q", path))
end

local function get_path()
	local dir = conf.home .. "/Pictures/screenshots"
	ensure_dir(dir)
	local stamp = os.date("%F_%T_")
	math.randomseed(os.time())
	local rnd = tostring(math.random(1000, 999999))
	local path = string.format("%s/%s%s.png", dir, stamp, rnd)
	return path
end

local function to_clip_image(path)
	if not path then
		return
	end
	sh(string.format(conf.xclip_image, path))
end

local function to_clip_text(text)
	if not text or text == "" then
		return
	end
	sh(string.format(conf.xclip_text, text))
end

-- Вызывает maim и дергает cb(path, ok) после завершения
local function call_screenshot_command(args, cb)
	local path = get_path()
	local cmd = string.format("maim %s %q", args or "", path)
	awful.spawn.easy_async_with_shell(cmd, function(_, _, _, code)
		local ok = (code == 0)
		if not ok then
			notify("error", "can't take screen", "critical")
		end
		if cb then
			cb(path, ok)
		end
	end)
end

local function upload(path, cb)
	-- простой аплоад через curl; адаптируй под свой API
	local base = path:match("([^/]+)$") or "shot.png"
	local cmd =
		string.format("curl -fsS -X POST -F 'file=@%q;type=image/png;filename=%q' %q", path, base, conf.imgur.url)
	awful.spawn.easy_async_with_shell(cmd, function(out, err, reason, code)
		if code ~= 0 then
			notify("upload", "Upload failed", "critical")
			if cb then
				cb(nil)
			end
		else
			if cb then
				cb((out or ""):gsub("%s+$", ""))
			end
		end
	end)
end

local function rofi_dmenu(items, prompt)
	local list = table.concat(items, "\n")
	local cmd = "rofi -dmenu -p " .. (prompt or "select")
	local out = sh_sync(string.format("printf %%s %q | %s", list, cmd))
	if not out then
		return nil
	end
	out = out:gsub("%s+$", "")
	return out ~= "" and out or nil
end

-- === публичные экшены ===
function M.take_screenshot()
	call_screenshot_command("-s", function(path, ok)
		if not ok then
			return
		end
		to_clip_image(path)
	end)
end

function M.recognize_qr()
	-- Поток в stdout -> zbarimg -> в буфер
	local cmd = "maim -qs | zbarimg -q --raw - | xclip -selection clipboard -f"
	sh(cmd, function(_, _, code)
		if code ~= 0 then
			notify("error", "can't screenshot", "critical")
		end
	end)
end

function M.take_full_screenshot()
	call_screenshot_command("", function(path, ok)
		if not ok then
			return
		end
		to_clip_image(path)
	end)
end

function M.take_screen_and_upload()
	call_screenshot_command("-s", function(path, ok)
		if not ok then
			return
		end
		upload(path, function(link)
			if not link then
				return
			end
			to_clip_text(link)
			notify("screenshot", "link in clipboard: " .. link, "normal")
		end)
	end)
end

function M.take_screenshot_alternative()
	local variants = {
		recognize_qr = M.recognize_qr,
		take_full_screenshot = M.take_full_screenshot,
		take_screen_and_upload = M.take_screen_and_upload,
		take_screenshot = M.take_screenshot,
	}
	local names = {}
	for k, _ in pairs(variants) do
		table.insert(names, k)
	end
	table.sort(names)
	local pick = rofi_dmenu(names, "screenshot")
	if not pick then
		return
	end
	local fn = variants[pick]
	if fn then
		fn()
	end
end

return M
