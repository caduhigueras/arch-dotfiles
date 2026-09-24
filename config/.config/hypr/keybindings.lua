-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local vars = require("defaults")
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

----------------------------------
--        System Bindings        --
----------------------------------
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(vars.terminal .. ' --working-directory="$HOME"'), { description = "Open Main Terminal (" .. vars.terminal .. ")" })
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(vars.alt_terminal), { description = "Open Alternative Terminal (" .. vars.alt_terminal .. ")" })
hl.bind(mainMod .. " + Z", hl.dsp.window.close(), { description = "Close Active Window" })
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(vars.file_manager .. " --new-window"), { description = "Open File Manager" })
-- Toggle float + center in one bind (both were bound to mainMod+V in the original config)
hl.bind(mainMod .. " + V", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.center())
end, { description = "Toggle Float Window" })
-- hl.bind(mainMod .. " + CTRL + V", function()
-- 	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
-- 	hl.dispatch(hl.dsp.window.resize({ x = "80%", y = "2%" }))
-- 	hl.dispatch(hl.dsp.window.center())
-- end, { description = "Toggle Float Window and resize" })
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.pin({ action = "toggle" }), { description = "Pin Active Floating Window" })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle Split Window" })
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --raw | satty -f -"), { description = "Screenshot Selected Region" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m active -m output --raw | satty -f -"), { description = "Screenshot Full Active Window" })
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("hyprcap rec -s region -w -n"), { description = "Screen Record a Selected Region" })
hl.bind("CTRL + SHIFT + PRINT", hl.dsp.exec_cmd("hyprcap rec -s window:active -w -n"), { description = "Screen Record Full Active Window" })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { description = "Suspend" })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("gnome-calculator"), { description = "Open Calculator" })
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd("wallpaper-toggle && hyprpaper-restart"), { description = "Toggle Wallpaper" })

----------------------------------
--         Menu Bindings         --
----------------------------------
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(vars.menu .. " -H -N"), { description = "Open Main Menu" })
hl.bind(mainMod .. " + CTRL + Space", hl.dsp.exec_cmd("walker -m menus:kr_menu --minheight 1 -HN"), { description = "Open KodingRocks Menu" })
hl.bind(
	mainMod .. " + B",
	hl.dsp.exec_cmd('walker-google-search "' .. vars.search_browser .. ' --new-window" "$(walker --dmenu -I --minheight 1 -p \'Search on Google...\')"'),
	{ description = "Search on Google" }
)
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("walker -m clipboard"), { description = "Open Clipboard Menu" })
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("walker -m menus:power_menu --minheight 1 -HNn"), { description = "Open Power Menu" })
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("walker -m menus:screenshots_menu --minheight 1 -HNn"), { description = "Open Screenshots Menu" })
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("walker -m menus:dev_menu --minheight 1 -HN"), { description = "Open Dev Menu" })
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("walker -m menus:config_files_menu --minheight 1 -H"), { description = "Open Config Menu" })
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("walker -m menus:system_menu --minheight 1 -HN"), { description = "Open System Menu" })
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("walker -m menus:setup_menu --minheight 1 -HN"), { description = "Open Setup Menu" })
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("walker -m menus:shortcuts_menu --minheight 1 -HN"), { description = "Open Shortcuts Menu" })
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd("startup-apps"), { description = "Run Startup Apps Placement (manual, see startupApps.lua)" })

----------------------------------
--         Window Focus          --
----------------------------------
-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }), { description = "Switch Focus to the Left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }), { description = "Switch Focus to the Right" })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }), { description = "Switch Focus Up" })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }), { description = "Switch Focus Down" })

----------------------------------
--         Window Swap           --
----------------------------------
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap Window to the Left" })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }), { description = "Swap Window to the Right" })
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.move({ direction = "l" }), { description = "Move Window to the Left" })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ direction = "r" }), { description = "Move Window to the Right" })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "u" }), { description = "Move Window Up" })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "d" }), { description = "Move Window Down" })

----------------------------------
--      Virtual Desktops         --
--   Desk Manipulation           --
----------------------------------
-- Requires the hyprland-virtual-desktops plugin (see plugins.lua)
local deskKeys = {
	{ id = 1, digit = "1", kp = "KP_End" },
	{ id = 2, digit = "2", kp = "KP_Down" },
	{ id = 3, digit = "3", kp = "KP_Page_Down" },
	{ id = 4, digit = "4", kp = "KP_Left" },
	{ id = 5, digit = "5", kp = "KP_Begin" },
}

local function vdAction(fname, id)
	return function()
		hl.plugin.virtual_desktops[fname](tostring(id))
	end
end

for _, d in ipairs(deskKeys) do
	hl.bind(mainMod .. " + " .. d.digit, vdAction("vdesk", d.id), { description = "Switch to Desk " .. d.id })
	hl.bind(mainMod .. " + " .. d.kp, vdAction("vdesk", d.id), { description = "Switch to Desk " .. d.id })

	hl.bind(mainMod .. " + SHIFT + " .. d.digit, vdAction("movetodesk", d.id), { description = "Move Active Window and go to Desk " .. d.id })
	hl.bind(mainMod .. " + SHIFT + " .. d.kp, vdAction("movetodesk", d.id), { description = "Move Active Window and go to Desk " .. d.id })

	hl.bind(mainMod .. " + CTRL + SHIFT + " .. d.digit, vdAction("movetodesksilent", d.id), { description = "Send Active Window to Desk " .. d.id })
	hl.bind(mainMod .. " + CTRL + SHIFT + " .. d.kp, vdAction("movetodesksilent", d.id), { description = "Send Active Window to Desk " .. d.id })
end

----------------------------------
--      WEB APPs and APPS        --
----------------------------------
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("webapp-launcher https://bitbucket.org/onedirect/workspace/overview/"), { description = "Open Bitbucket" })
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd('webapp-launcher "https://chatgpt.com/"'), { description = "Open ChatGPT" })
hl.bind(mainMod .. " + CTRL + SHIFT + C", hl.dsp.exec_cmd('webapp-launcher "https://claude.ai/new"'), { description = "Open Claude" })
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd('webapp-launcher "https://calendar.google.com/"'), { description = "Open Google Calendar" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd('webapp-launcher "https://docs.google.com/spreadsheets"'), { description = "Open Excel" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd('webapp-launcher "https://www.figma.com/files/team/"'), { description = "Open Figma" })
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd('webapp-launcher "https://github.com/"'), { description = "Open GitHub" })
hl.bind(
	mainMod .. " + SHIFT + H",
	hl.dsp.exec_cmd("/usr/bin/chromium --new-window --profile-directory=Default --app-id=bnffplbjjceinmcdeoehajahfhcgdbhm"),
	{ description = "Open HubSpot" }
)
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd("webapp-launcher https://onedirect.atlassian.net/jira/software/c/projects/DS1/boards/33"), { description = "Open Jira" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("webapp-launcher http://10.34.128.229:8080/"), { description = "Open Jenkins Preprod" })
hl.bind(mainMod .. " + CTRL + SHIFT + K", hl.dsp.exec_cmd("webapp-launcher http://10.34.128.78:8080/"), { description = "Open Jenkins Prod" })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd('webapp-launcher "https://gmail.com/"'), { description = "Open Gmail" })
hl.bind(mainMod .. " + CTRL + SHIFT + M", hl.dsp.exec_cmd('webapp-launcher "https://mail.proton.me/u/0/inbox"'), { description = "Open Proton Mail" })
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("webapp-launcher https://onedirect-w5.sentry.io/issues/"), { description = "Open Sentry" })
-- Obsidian workspace toggle + launch, both bound to mainMod+SHIFT+O in the original config
hl.bind(mainMod .. " + SHIFT + O", function()
	hl.dispatch(hl.dsp.workspace.toggle_special("obsidian"))
	hl.dispatch(hl.dsp.exec_cmd("uwsm app -- obsidian --enable-wayland-ime"))
end, { description = "Open Obsidian Workspace / Launch Obsidian" })
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("uwsm app -- postman"), { description = "Open Postman" })
-- hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("webapp-launcher https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1"), { description = "Open AWS Console" })
hl.bind(
	mainMod .. " + SHIFT + T",
	hl.dsp.exec_cmd("/opt/brave-bin/brave --profile-directory=Default --app-id=ompifgpmddkgmclendfeacglnodjjndh %U"),
	{ description = "Open Teams" }
)
hl.bind(
	mainMod .. " + SHIFT + Y",
	hl.dsp.exec_cmd("/opt/brave-bin/brave --profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml"),
	{ description = "Open Youtube" }
)
-- Whatsapp workspace toggle + launch, both bound to mainMod+SHIFT+W in the original config
hl.bind(mainMod .. " + SHIFT + W", function()
	hl.dispatch(hl.dsp.workspace.toggle_special("whatsapp"))
	hl.dispatch(hl.dsp.exec_cmd('webapp-launcher "https://web.whatsapp.com/"'))
end, { description = "Open Whatsapp Workspace / Launch Whatsapp" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("uwsm app -- chromium"), { description = "Open Chromium" })
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("uwsm app -- chromium --incognito"), { description = "Open Chromium (Incognito)" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("webapp-launcher https://outlook.office.com/mail"), { description = "Open Email" })
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("uwsm app -- firefox"), { description = "Open Firefox" })
hl.bind(mainMod .. " + CTRL + F", hl.dsp.exec_cmd("uwsm app -- firefox --private-window"), { description = "Open Firefox (Incognito)" })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("phpstorm"), { description = "Open PhpStorm" })
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rustrover"), { description = "Open RustRover" })
-- Scratches workspace toggle + create-scratch-file, both bound to mainMod+CTRL+S in the original config
hl.bind(mainMod .. " + CTRL + S", function()
	hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
	hl.dispatch(hl.dsp.exec_cmd(vars.terminal .. " -e scratch-create"))
end, { description = "Open Scratches Workspace / Create a Scratch File" })

----------------------------------
--   Custom Work related Binds   --
----------------------------------
hl.bind(mainMod .. " + ALT + 0", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://magento2-prod.onedirect.fr/admin_lhhc2l/"), { description = "Open Prod Admin (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_Insert", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://magento2-prod.onedirect.fr/admin_lhhc2l/"), { description = "Open Prod Admin (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 0", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://magento2-prod.onedirect.fr/admin_lhhc2l/"), { description = "Open Prod Admin (Chromium)" })
-- NOTE: original was `bindd = $mainMod CTRL KP_Insert, 0, ...` -- KP_Insert was
-- placed in the modifier field, which isn't a valid modifier and likely never
-- bound. Translated here as mainMod+CTRL+ALT+KP_Insert to match the sibling
-- pattern used by every other entry in this block; please verify this is what
-- you intended.
hl.bind(mainMod .. " + CTRL + ALT + KP_Insert", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://magento2-prod.onedirect.fr/admin_lhhc2l/"), { description = "Open Prod Admin (Chromium)" })
hl.bind(mainMod .. " + ALT + 1", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://magento2-preprod.onedirect.fr/admin_lhhc2l/"), { description = "Open Preprod Admin (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_End", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://magento2-preprod.onedirect.fr/admin_lhhc2l/"), { description = "Open Preprod Admin (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 1", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://magento2-preprod.onedirect.fr/admin_lhhc2l/"), { description = "Open Preprod Admin (Chromium)" })
hl.bind(mainMod .. " + CTRL + ALT + KP_End", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://magento2-preprod.onedirect.fr/admin_lhhc2l/"), { description = "Open Preprod Admin (Chromium)" })
hl.bind(mainMod .. " + ALT + 2", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.co.uk/"), { description = "Open UK (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_Down", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.co.uk/"), { description = "Open UK (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 2", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.co.uk/"), { description = "Open UK (Chromium)" })
hl.bind(mainMod .. " + CTRL + ALT + KP_Down", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.co.uk/"), { description = "Open UK (Chromium)" })
hl.bind(mainMod .. " + ALT + 3", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.fr/"), { description = "Open FR (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_Page_Down", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.fr/"), { description = "Open FR (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 3", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.fr/"), { description = "Open FR (Chromium)" })
hl.bind(mainMod .. " + CTRL + ALT + KP_Page_Down", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.fr/"), { description = "Open FR (Chromium)" })
hl.bind(mainMod .. " + ALT + 4", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.es/"), { description = "Open ES (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_Left", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.es/"), { description = "Open ES (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 4", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.es/"), { description = "Open ES (Chromium)" })
hl.bind(mainMod .. " + CTRL + ALT + KP_Left", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.es/"), { description = "Open ES (Chromium)" })
hl.bind(mainMod .. " + ALT + 5", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.pt/"), { description = "Open PT (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_Begin", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.pt/"), { description = "Open PT (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 5", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.pt/"), { description = "Open PT (Chromium)" })
hl.bind(mainMod .. " + CTRL + ALT + KP_Begin", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.pt/"), { description = "Open PT (Chromium)" })
hl.bind(mainMod .. " + ALT + 6", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.it/"), { description = "Open IT (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_Right", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.it/"), { description = "Open IT (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 6", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.it/"), { description = "Open IT (Chromium)" })
hl.bind(mainMod .. " + CTRL + ALT + KP_Right", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.it/"), { description = "Open IT (Chromium)" })
hl.bind(mainMod .. " + ALT + 7", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.de/"), { description = "Open DE (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_Home", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.de/"), { description = "Open DE (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 7", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.de/"), { description = "Open DE (Chromium)" })
hl.bind(mainMod .. " + CTRL + ALT + KP_Home", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.de/"), { description = "Open DE (Chromium)" })
hl.bind(mainMod .. " + ALT + 8", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.nl/"), { description = "Open NL (Firefox)" })
hl.bind(mainMod .. " + ALT + KP_Up", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://www.onedirect.nl/"), { description = "Open NL (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + 8", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.nl/"), { description = "Open NL (Chromium)" })
hl.bind(mainMod .. " + CTRL + ALT + KP_Up", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://www.onedirect.nl/"), { description = "Open NL (Chromium)" })
hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://m2.one.es/"), { description = "Open Local Home (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + H", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://m2.one.es/"), { description = "Open Local Home (Chromium)" })
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://m2.one.es/productos/plantronics/plantronics-cs540/"), { description = "Open Local Product (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + P", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://m2.one.es/productos/plantronics/plantronics-cs540/"), { description = "Open Local Product (Chromium)" })
hl.bind(mainMod .. " + ALT + A", hl.dsp.exec_cmd("/usr/bin/firefox --new-window=https://m2.one.es/admin/"), { description = "Open Local Admin (Firefox)" })
hl.bind(mainMod .. " + CTRL + ALT + A", hl.dsp.exec_cmd("/usr/bin/chromium --new-window=https://m2.one.es/admin/"), { description = "Open Local Admin (Chromium)" })
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("nmcli connection up prod"), { description = "Open Prod VPN" })
hl.bind(mainMod .. " + CTRL + ALT + V", hl.dsp.exec_cmd("nmcli connection down prod"), { description = "Close Prod VPN" })
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd("nmcli connection up preprod"), { description = "Open Preprod VPN" })
hl.bind(mainMod .. " + CTRL + ALT + E", hl.dsp.exec_cmd("nmcli connection down preprod"), { description = "Close Preprod VPN" })
hl.bind(mainMod .. " + ALT + D", hl.dsp.exec_cmd(vars.terminal .. ' -e "cd /home/arch/app/magento/m2.one/docker/ && docker compose up -d"'), { description = "Start m2.one docker" })

----------------------------------
--      Special Workspaces       --
----------------------------------
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), { description = "Open Scratch Workspace" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), { description = "Move to Scratchpad" })
hl.bind(mainMod .. " + A", hl.dsp.workspace.toggle_special("auxiliary"), { description = "Open Auxiliary Workspace" })
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "special:auxiliary" }), { description = "Move to Auxiliary Workspace" })
hl.bind(mainMod .. " + Q", hl.dsp.workspace.toggle_special("qnav"), { description = "Open Quick Navigation Workspace" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.move({ workspace = "special:qnav" }), { description = "Move to Quick Navigation Workspace" })
hl.bind(mainMod .. " + O", hl.dsp.workspace.toggle_special("obsidian"), { description = "Open Obsidian Workspace" })
hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("whatsapp"), { description = "Open Whatsapp Workspace" })

-- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

----------------------------------
--     Move / resize Windows     --
----------------------------------
hl.bind(mainMod .. " + CTRL + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -400, y = 0, relative = true }), { description = "Expand/Resize Active Window to the Left" })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 400, y = 0, relative = true }), { description = "Resize Active Window to the Right" })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -400, relative = true }), { description = "Resize Active Window Up" })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 400, relative = true }), { description = "Resize Active Window Down" })

----------------------------------
--   Laptop / Multimedia Keys    --
----------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
