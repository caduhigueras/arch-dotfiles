-- Hyprland config entrypoint, migrated from hyprland.conf's `source =` list.
-- See https://wiki.hypr.land/Configuring/Start/
--
-- Since Hyprland 0.55, hyprlang (the old .conf syntax) is deprecated in favor
-- of this Lua format. When hyprland.lua is present it takes precedence over
-- hyprland.conf, which is only checked at startup -- switching back to the
-- .conf requires deleting/renaming this file and restarting Hyprland.

require("defaults")
require("monitors")
require("autostart")
require("env")
require("permissions")
require("lookAndFeel")
require("input")
require("keybindings")
require("workspaces")
require("plugins")
require("startupApps")
