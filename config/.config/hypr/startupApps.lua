-- Launch specific apps on session start and pin each one to a vdesk +
-- monitor (or a "magic"/special workspace), without a launch/wait/move race.
--
-- Why this uses the window.open event instead of exec_cmd's PID-scoped rules
-- (`hl.dsp.exec_cmd(cmd, { monitor = ... })`, see Window-Rules docs): most of
-- these commands go through webapp-launcher, which execs through `setsid`
-- and `uwsm app --`. Both fork, so the actual browser window ends up under a
-- different PID than the one exec_cmd captured, and PID-scoped rules
-- silently don't apply ("if your process forks and then the fork opens a
-- window, this will not work" -- per the wiki). Matching on the mapped
-- window itself sidesteps that.
--
-- Monitor numbering (see monitors.lua for the desc: values behind these):
--   1 = laptop (x=0)   2 = external left (x=1600)   3 = external right (x=3520)
--
-- STATUS (2026-09-08, live-tested against a running session via `runStartupApps()`
-- + `hyprctl repl`, both with the queue/logging revision and after the fix below):
--   CONFIRMED WORKING: window.open fires reliably; w.class/w.title/w.address
--   are plain field reads; hl.dsp.window.move({monitor=, window=}) moves a
--   specific window between monitors; the FIFO-per-class queue correctly
--   disambiguated both same-class pairs (the two ghostty launches and the
--   two `firefox --new-window` launches) by launch order, every single time.
--   `ghostty --class=X` does NOT override the window class (fixed: both
--   terminal launches now share the real default class, per the FIFO note
--   above).
--   FOUND AND FIXED: the very first full run (all 15 apps queued, opening
--   within ~10s of each other) placed every app's vdesk correctly but almost
--   all monitor assignments were wrong -- most apps piled onto whichever
--   monitor a *different*, concurrently-opening app happened to be using.
--   Root cause: `place()` used to call hl.dispatch(hl.dsp.focus({window=w}))
--   before acting, so it could target "the active window" -- but focus is
--   global shared state, and with ~10 windows opening in the same second,
--   one window's focus+move+movetodesksilent sequence could get interleaved
--   by another's. Fix: movetodesksilent accepts the same "vdesk,selector"
--   combined string the raw hyprctl dispatcher takes (confirmed live:
--   `movetodesksilent("4,address:0x...")` moved a window without focusing it
--   first) -- so place() below now always targets `w` explicitly by address
--   and never touches focus.
--   STILL BROKEN AFTER THAT FIX, THEN FOUND AND FIXED AGAIN: removing focus
--   didn't help -- re-ran the same 15-app batch and monitor placement was
--   still wrong across the board (nothing ever landed on eDP-1, for
--   instance). Isolated it: a single, standalone placement (one window,
--   nothing else happening) applied correctly and *immediately*. It's
--   specifically *concurrent* placements that fail -- with ~10 windows
--   opening in the same second, most of their window.move dispatches
--   silently don't apply. Consistent with the aquamarine backend's own
--   "Cannot commit when a page-flip is awaiting" errors seen in
--   hyprland.log elsewhere: rapid concurrent monitor-related operations get
--   dropped. Fix: placements are now serialized through a small queue
--   (PLACE_DELAY_MS apart, see drain() below) instead of applied immediately
--   inline in window.open, so only one is ever in flight at a time.
--   ALL OF THE ABOVE WAS RE-VERIFIED CORRECT VIA MANUAL TESTING (running
--   `runStartupApps()` by hand through `hyprctl repl` after the fixes
--   above): 100% of 15 apps landed on the exact intended vdesk/monitor/
--   special-workspace, twice in a row.
--   BUT: on the next real cold boot, everything opened unmoved again.
--   Diagnosis from that boot's log (LOGFILE below): (1) only eDP-1 was
--   visible in hl.get_monitors() at the moment hyprland.start fired --
--   externals hadn't finished DRM setup yet, so every non-eDP-1 monitor=
--   silently resolved to nil -- and (2) more puzzlingly, EVERY window.open
--   event reported "no queued placement", even for classes clearly enqueued
--   moments earlier in the very same log. (2) is not fully explained: ruled
--   out autostart.lua's `hyprpm reload -n` (it only ensures the plugin .so
--   is loaded, doesn't reparse the Lua config -- confirmed via `hyprpm
--   reload --help`, and via waybar/hyprpaper each having exactly one process
--   this boot, meaning hyprland.start's handlers only ran once), and ruled
--   out closures over local upvalues losing their bond across event types
--   (tested live: a local table populated by one closure was correctly
--   still visible from an unrelated hl.on("window.open", ...) closure
--   several seconds later). Given (1) is confirmed and (2) is not, and both
--   only manifest on a genuine hyprland.start firing (never reproduced via
--   a manual runStartupApps() call), the fix below treats it as a startup
--   timing issue: hyprland.start now polls for the expected monitor count
--   before running anything at all, instead of running immediately. This is
--   a defensive fix for a not-fully-understood failure mode -- if apps
--   still don't move after this, LOGFILE from that boot is the next thing
--   to read, and re-test with `runStartupApps()` manually first to confirm
--   the placement logic itself still isn't the problem before suspecting
--   this file further.

local LOGFILE = "/tmp/hypr-startup-apps.log"

local function log(msg)
	local f = io.open(LOGFILE, "a")
	if f then
		f:write(os.date("%H:%M:%S") .. " " .. msg .. "\n")
		f:close()
	end
end

local vars = require("defaults")

local function monitorsByX()
	local byX = {}
	local ok, monitors = pcall(hl.get_monitors)
	if not ok then
		log("ERROR hl.get_monitors() failed: " .. tostring(monitors))
		return byX
	end
	for _, m in ipairs(monitors) do
		byX[m.x] = m.name
		log("monitor x=" .. tostring(m.x) .. " -> " .. tostring(m.name))
	end
	return byX
end

-- FIFO queue per window class: entries are consumed in launch order as
-- matching windows open. Needed because e.g. two plain `firefox --new-window`
-- launches (and now both ghostty launches too, see STATUS above) share the
-- same class -- launch order decides which placement each one gets.
local queues = {}

local function enqueue(class, placement)
	queues[class] = queues[class] or {}
	table.insert(queues[class], placement)
	log("enqueued class=" .. tostring(class) .. " vdesk=" .. tostring(placement.vdesk) .. " monitor=" .. tostring(placement.monitor) .. " workspace=" .. tostring(placement.workspace))
end

-- Targets `w` explicitly throughout (via its address) rather than focusing it
-- and relying on "active window" -- focus is global, shared state, and with
-- many apps opening within the same second at startup, a focus-then-act
-- sequence for one window can get stomped on by another window's placement
-- racing in between. Confirmed live: movetodesksilent accepts the same
-- "vdesk,window_selector" combined string the raw hyprctl dispatcher takes
-- (e.g. "4,address:0x..."), so it never needs the window to be active.
local function place(w, placement)
	if placement.monitor then
		hl.dispatch(hl.dsp.window.move({ monitor = placement.monitor, follow = false, window = w }))
	end
	if placement.vdesk and hl.plugin.virtual_desktops ~= nil then
		hl.plugin.virtual_desktops.movetodesksilent(tostring(placement.vdesk) .. ",address:" .. w.address)
	end
	if placement.workspace then
		hl.dispatch(hl.dsp.window.move({ workspace = placement.workspace, follow = false, window = w }))
	end
end

-- Placements are applied one at a time, PLACE_DELAY_MS apart, instead of
-- immediately inline in the window.open handler below. Confirmed live: a
-- single, isolated placement applies correctly and immediately, but when
-- several windows open within the same second (normal at startup) and each
-- fires its own window.move dispatch back-to-back, most of them silently
-- don't apply -- consistent with the aquamarine backend's own "Cannot commit
-- when a page-flip is awaiting" errors seen in the Hyprland log, i.e. rapid
-- concurrent monitor-related operations get dropped. Serializing them with a
-- gap avoids that entirely, at the cost of ~PLACE_DELAY_MS per app in total
-- startup placement time.
local PLACE_DELAY_MS = 250
local pending = {}
local draining = false

local function drain()
	if #pending == 0 then
		draining = false
		return
	end
	draining = true
	local item = table.remove(pending, 1)
	local ok, err = pcall(place, item.w, item.placement)
	if not ok then
		log("ERROR applying placement: " .. tostring(err))
	end
	hl.timer(drain, { timeout = PLACE_DELAY_MS, type = "oneshot" })
end

local function enqueuePlacement(w, placement)
	table.insert(pending, { w = w, placement = placement })
	if not draining then
		drain()
	end
end

hl.on("window.open", function(w)
	log("window.open class=" .. tostring(w.class) .. " title=" .. tostring(w.title))
	local ok, err = pcall(function()
		local q = queues[w.class]
		if q and #q > 0 then
			local placement = table.remove(q, 1)
			log("  -> queued for placement: vdesk=" .. tostring(placement.vdesk) .. " monitor=" .. tostring(placement.monitor) .. " workspace=" .. tostring(placement.workspace))
			enqueuePlacement(w, placement)
		else
			log("  -> no queued placement for this class")
		end
	end)
	if not ok then
		log("ERROR in window.open handler: " .. tostring(err))
	end
end)

-- Exposed globally so it can be re-triggered by hand via `hyprctl repl
-- runStartupApps()` -- hyprland.start only fires once at compositor launch,
-- so this is the only way to re-test placement logic without a full restart.
function runStartupApps()
	log("=== runStartupApps (manual or hyprland.start) ===")
	local ok, err = pcall(function()
		local mon = monitorsByX()

		local function exec(cmd, class, placement)
			if placement then
				enqueue(class, placement)
			end
			hl.exec_cmd(cmd)
		end

		-- vdesk 1: Coding PHP and JS
		exec(vars.terminal .. ' --working-directory="$HOME"', "com.mitchellh.ghostty", { vdesk = 1, monitor = mon[0] })
		exec("/opt/brave-bin/brave --profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml", "brave-agimnkijcaahngcdmfeangaknmldooml-Default", { vdesk = 1, monitor = mon[0] })
		exec("phpstorm", "jetbrains-phpstorm", { vdesk = 1, monitor = mon[1600] })
		exec("uwsm app -- firefox --new-window", "firefox", { vdesk = 1, monitor = mon[3520] })

		-- vdesk 2: Communicaion [sic, matches plugins.lua]
		exec('webapp-launcher "https://gmail.com/"', "brave-gmail.com__-Default", { vdesk = 2, monitor = mon[0] })
		exec("/opt/brave-bin/brave --profile-directory=Default --app-id=ompifgpmddkgmclendfeacglnodjjndh %U", "brave-ompifgpmddkgmclendfeacglnodjjndh-Default", { vdesk = 2, monitor = mon[1600] })
		exec("webapp-launcher https://outlook.office.com/mail", "brave-outlook.office.com__mail-Default", { vdesk = 2, monitor = mon[3520] })

		-- vdesk 3: Coding Rust -- shares ghostty's default class with the
		-- vdesk-1 terminal above; FIFO queue + launch order disambiguates
		-- (see STATUS note: --class= does not actually work here).
		exec(vars.terminal, "com.mitchellh.ghostty", { vdesk = 3, monitor = mon[1600] })
		exec("/usr/bin/chromium --new-window --profile-directory=Default --app-id=bnffplbjjceinmcdeoehajahfhcgdbhm", "chrome-bnffplbjjceinmcdeoehajahfhcgdbhm-Default", { vdesk = 3, monitor = mon[3520] })

		-- vdesk 4: Research and Personal
		exec('webapp-launcher "https://github.com/"', "brave-github.com__-Default", { vdesk = 4, monitor = mon[0] })
		exec("webapp-launcher https://onedirect.atlassian.net/jira/software/c/projects/DS1/boards/33", "brave-onedirect.atlassian.net__jira_software_c_projects_DS1_boards_33-Default", { vdesk = 4, monitor = mon[1600] })
		exec("webapp-launcher https://bitbucket.org/onedirect/workspace/overview/", "brave-bitbucket.org__onedirect_workspace_overview_-Default", { vdesk = 4, monitor = mon[3520] })

		-- vdesk 5: Scratches -- NOTE: Factorial isn't bound to any existing
		-- keybinding, so this URL/class is inferred from your currently-open
		-- window (class brave-app.factorialhr.com__dashboard-Default, title
		-- "Home | Factorial") rather than sourced from keybindings.lua. Verify.
		exec('webapp-launcher "https://app.factorialhr.com/dashboard"', "brave-app.factorialhr.com__dashboard-Default", { vdesk = 5, monitor = mon[1600] })

		-- Magic / special workspaces -- no vdesk involved, so no monitor pin either.
		exec('webapp-launcher "https://web.whatsapp.com/"', "brave-web.whatsapp.com__-Default", { workspace = "special:whatsapp" })
		exec("uwsm app -- obsidian --enable-wayland-ime", "md.obsidian.Obsidian", { workspace = "special:obsidian" })
		exec("uwsm app -- firefox --new-window", "firefox", { workspace = "special:qnav" })
	end)
	if not ok then
		log("ERROR in runStartupApps: " .. tostring(err))
	end
end

-- Confirmed on a real cold boot: hyprland.start can fire before all monitors
-- have finished DRM setup -- one boot saw only eDP-1 in hl.get_monitors() at
-- that exact moment (externals connect a little later), so every monitor=
-- placement silently fell back to nil. Poll for the expected monitor count
-- (retrying every 500ms, up to 10 times = 5s) before running anything, so
-- exec/enqueue only happens once the real layout is visible. Falls through
-- and runs anyway after the cap, in case only 1-2 monitors are ever going to
-- be connected (e.g. laptop-only).
local EXPECTED_MONITOR_COUNT = 3

local function waitForMonitorsThenRun(attempt)
	attempt = attempt or 1
	local ok, monitors = pcall(hl.get_monitors)
	local count = (ok and monitors) and #monitors or 0
	log("startup monitor check #" .. attempt .. ": count=" .. count)
	if count >= EXPECTED_MONITOR_COUNT or attempt >= 10 then
		runStartupApps()
	else
		hl.timer(function()
			waitForMonitorsThenRun(attempt + 1)
		end, { timeout = 500, type = "oneshot" })
	end
end

-- AUTO-TRIGGER DISABLED (2026-09-08): the monitor-count polling above didn't
-- fix it either -- still broken on the next real cold boot, same as before.
-- The root cause is still not understood (see the STATUS block at the top of
-- this file for what's been ruled out), and manual triggering has now been
-- confirmed reliable across multiple real tests, so that's the approach
-- going forward instead of continuing to chase a boot-time-only failure.
-- Run manually with `hyprctl repl 'runStartupApps()'`, or the `startup-apps`
-- bin script, or the $mainMod+F6 keybind (see keybindings.lua) -- all three
-- call the exact same runStartupApps() defined above.
--
-- hl.on("hyprland.start", function()
-- 	waitForMonitorsThenRun()
-- end)
