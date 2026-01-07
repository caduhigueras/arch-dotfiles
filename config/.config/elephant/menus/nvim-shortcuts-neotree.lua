Name = "nvim_shortcuts_neotree"
NamePretty = "Neotree Shortcuts"
-- Icon = "applications-other"
Cache = true
HideFromProviderlist = false
Description = "List shortcuts from Neotree"
SearchName = true

local json = require("dkjson") -- use json as the variable

local function read_file(path)
	local f, err = io.open(path, "r")
	if not f then
		return nil, ("Failed to open file: %s"):format(err)
	end

	local content = f:read("*a")
	f:close()
	return content
end

local function read_json(path)
	local content, err = read_file(path)
	if not content then
		return nil, err
	end

	local obj, pos, decode_err = json.decode(content, 1, nil)
	if decode_err then
		return nil, ("Invalid JSON: %s"):format(decode_err)
	end

	return obj
end

function GetEntries()
	local config_map = "/home/arch/.local/share/arch-dotfiles/config/.config/walker/json/neovim_neotree.json"
	local entries = {}

	local entries, err = read_json(config_map)
	if not entries then
		error(err)
	end

	return entries
end
