Name = "hypr_keybindings"
NamePretty = "Hyprland Keybindings"
Icon = "applications-other"
Cache = true
-- Action = "notify-send %VALUE%"
HideFromProviderlist = false
Description = "List all keybindings configured in Hyprland"
SearchName = true

function GetEntries()
	local entries = {}
	local cjson = require("dkjson")
	local binds = cjson.decode(cmd_output("hyprctl binds -j"))

	for _, b in ipairs(binds) do
		local modmask_mapped = key_to_name(b.modmask)
		local key = b.key
		local label = get_action_label(b)

		table.insert(entries, {
			Text = label,
			Subtext = string.format("%s%s", tostring(modmask_mapped), tostring(key)),
			Value = "",
			Actions = {},
		})
	end
	return entries
end

function cmd_output(cmd)
	local f = assert(io.popen(cmd, "r"))
	local s = f:read("*a")
	f.close(f)
	return s
end

evdev_keynames = {
	[1] = "SHIFT + ",
	[0] = "",
	[4] = "CTRL + ",
	[5] = "CTRL + SHIFT + ",
	[64] = "SUPER + ",
	[65] = "SUPER + SHIFT + ",
	[68] = "SUPER + CTRL + ",
}

function key_to_name(code)
	return evdev_keynames[code] or ("HEYCODE_" .. tostring(code) .. " + ")
end

function get_action_label(b)
	local desc = b.description or b.desc or b.comment
	if desc and desc ~= "" then
		return desc
	end

	local dispatcher = b.dispatcher or b.dispatch or ""
	local arg = b.arg or b.args or ""

	if dispatcher == "exec" and arg ~= "" then
		return arg
	end

	if arg ~= "" then
		return dispatcher .. " " .. arg
	end

	return dispatcher
end
