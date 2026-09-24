-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- Monitors are matched by `desc:` (make/model/serial from `hyprctl monitors
-- all`) rather than port name (DP-5 vs DP-6 depends on which physical port
-- it's plugged into, which is exactly what was changing between work/home).
-- A rule for a monitor that isn't currently connected is simply ignored, so
-- all locations' rules can just live here together -- nothing to toggle when
-- switching between them.

-- Laptop panel: always present, port name is stable, no need for desc:
hl.monitor({ output = "eDP-1", mode = "2560x1600@90", position = "0x0", scale = 1.6 })

-- Work: 2x Dell P2419H (desc: captured live via `hyprctl monitors all`)
hl.monitor({ output = "desc:Dell Inc. DELL P2419H 1BSYH73", mode = "1920x1080@60", position = "1600x0", scale = 1 })
hl.monitor({ output = "desc:Dell Inc. DELL P2419H 79LLYT2", mode = "1920x1080@60", position = "3520x0", scale = 1 })

-- Home: fill these in. Run `hyprctl monitors all` at home and copy each
-- monitor's "description:" line verbatim after "desc:" below.
-- hl.monitor({ output = "desc:REPLACE_WITH_HOME_MONITOR_1_DESCRIPTION", mode = "1920x1080@60", position = "1600x0", scale = 1 })
-- hl.monitor({ output = "desc:REPLACE_WITH_HOME_MONITOR_2_DESCRIPTION", mode = "1920x1080@60", position = "3520x0", scale = 1 })

-- Fallback: anything connected that doesn't match a rule above still gets a
-- sane preferred-mode, auto-positioned setup instead of being left alone.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
