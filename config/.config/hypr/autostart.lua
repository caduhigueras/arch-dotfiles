-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("mako")
	hl.exec_cmd("systemctl --user restart walker elephant")
	-- hl.exec_cmd("bash -lc 'test -f ~/.cache/hyprpm-vd-installed || (yes | hyprpm update && yes | hyprpm add https://github.com/levnikmyskin/hyprland-virtual-desktops && touch ~/.cache/hyprpm-vd-installed)'")
	hl.exec_cmd("hyprpm enable virtual-desktops || true")
	-- NOTE: `mako` was launched twice in the original autostart.conf (once here,
	-- once again at the end). Kept as-is (harmless -- mako just no-ops if already
	-- running) rather than silently changing behavior during the migration.
	hl.exec_cmd("mako")
end)
