-- {{
-- ltuyen's awesome window manager config
-- }}


-- {{ Load an library
pcall(require, "luarocks.loader")
require("awful.autofocus")
local awful = require("awful")
local gears = require("gears")
-- }}

-- {{ Autostart
local spawn_once_cmd = ([[pgrep -fU '%s' -- ']]):format(username) .. "%s'"
local function spawn_once(cmd)
	awful.spawn.easy_async_with_shell(spawn_once_cmd:format(cmd[1]), function(stdout, stderr, reason, exit_code)
		if exit_code > 0 then
			awful.spawn(cmd)
		end
	end)
end

awful.spawn.with_shell("picom --daemon --config " .. require 'gears.filesystem'.get_configuration_dir() .. "configuration/picom.conf")
spawn_once("lxpolkit")
spawn_once("udiskie")
spawn_once("xss-lock --transfer-sleep-lock slock")
awful.spawn.with_shell("cbatticon")
awful.spawn.with_shell("xrdb -merge ~/.Xresources")
awful.spawn.with_shell("nm-applet")
-- }}

-- {{ Variables
terminal = "st"

-- By default. loginctl was used as an reboot, poweroff and suspend commands because i'm using an non-systemd distro
-- Replace loginctl with systemctl if using systemd as an init.
rebootcmd = "loginctl reboot"
poweroffcmd = "loginctl poweroff"
suspendcmd = "loginctl suspend"
-- }}

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
local naughty = require("naughty")
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        app_name = "awesome window manager",
        urgency = "critical",
        title   = "Error occured"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-------------------
-- Initalization --
-------------------

-- Initalize theme
require 'beautiful'.init(require 'gears.filesystem'.get_configuration_dir() .. "theme/theme.lua")

require('configuration')

-- Garbage collection
gears.timer({
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = function ()
        collectgarbage("collect")
    end,
})
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
