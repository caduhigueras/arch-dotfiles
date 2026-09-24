-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules
--
-- NOTE: despite the filename (kept from workspaces.conf for a 1:1 migration),
-- this file only contains window rules -- there are no workspace rules defined.

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = { 20, "monitor_h-120" },
	float = true,
})

hl.window_rule({
	name = "general-opacity",
	match = { class = ".*" },
	opacity = "1.00 0.96",
})

hl.window_rule({
	name = "ghostty-opacity",
	match = { class = "^com\\.mitchellh\\.ghostty$" },
	opacity = "0.93 override 0.80 override",
})

hl.window_rule({
	name = "alacritty-opacity",
	match = { class = "^(Alacritty)$" },
	opacity = "0.93 override 0.80 override",
})

hl.window_rule({
	name = "phpstorm-opacity",
	match = { class = "^(jetbrains-phpstorm)$" },
	opacity = "0.93 override 0.80 override",
})

hl.window_rule({
	name = "remove-youtube-opacity",
	match = { title = "^(YouTube).*" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "remove-firefox-pip-opacity",
	match = { title = "Picture-in-Picture" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "remove-pip-opacity",
	match = { title = "Picture in picture" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "centered-floating-window",
	match = { class = "^(centered_float_window)$" },

	float = true,
	size = { 960, 600 },
	center = true,
})
