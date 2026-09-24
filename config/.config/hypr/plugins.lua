-- Requires the hyprland-virtual-desktops plugin (see autostart.lua:
-- `hyprpm enable virtual-desktops`).
-- https://github.com/levnikmyskin/hyprland-virtual-desktops
--
-- Guarded with the nil check the plugin's own README recommends for the Lua
-- config path, in case this file is parsed before the plugin has loaded.
if hl.plugin.virtual_desktops ~= nil then
	hl.plugin.virtual_desktops.stickyrule("class:^(brave-teams.microsoft.com).*,2")

	hl.config({
		plugin = {
			virtual_desktops = {
				names = "1:Coding PHP and JS, 2:Communicaion, 3:Coding Rust, 4:Research and Personal, 5:Scrathes",
				cycleworkspaces = 1,
				rememberlayout = "size",
				notifyinit = 0,
				verbose_logging = 0,
			},
		},
	})
end
