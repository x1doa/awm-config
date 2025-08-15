-- Load required modules
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require "gears"
local wibox = require "wibox"
local helpers = require "helpers"
require("awful.hotkeys_popup.keys")
local dpi = beautiful.xresources.apply_dpi
local gfs = require("gears.filesystem")
local bling = require "modules.bling"

--- Flash Focus
bling.module.flash_focus.enable()

--- Layout
tag.connect_signal(
    "request::default_layouts",
    function()
        awful.layout.append_default_layouts(
            {
                awful.layout.suit.floating,
                awful.layout.suit.tile,
                awful.layout.suit.max,
                bling.layout.centered,
                bling.layout.equalarea,
                bling.layout.deck,
                bling.layout.mstab,
                awful.layout.suit.spiral.dwindle
            }
        )
    end
)

--- Wallpaper
awful.screen.connect_for_each_screen(
    function(s)
        if beautiful.wall then
            local wallpaper = beautiful.wall

            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end

            gears.wallpaper.maximized(wallpaper, s, false, nil)
        end
    end
)

--- Menu
myawesomemenu = {
    {"Hotkeys", function()
            require "awful.hotkeys_popup".show_help(nil, awful.screen.focused())
        end},
    {"Reload Config", awesome.restart}
}

system = {
    {"Lock Screen", "slock"},
    {"Exit", function()
            awesome.quit()
        end},
    {"Reboot", rebootcmd},
    {"Poweroff", poweroffcmd},
    {"Suspend", suspendcmd},
    {"Change Screen Resolution", "arandr"}
}

screenshot = {
    {"Screenshot Now", "flameshot screen"},
    {"Manual Screenshot", "flameshot gui"},
    {"Screenshot for 10 Sec", "flameshot screen -d 10000"},
    {"Screenshot for 5 Sec", "flameshot screen -d 5000"}
}

applications = {
    {"Text Editor", terminal .. " -e nvim"},
    {"Music Player", terminal .. " -e cmus"},
    {"Terminal", terminal},
    {"Task Manager", terminal .. " -e htop"}
}

mymainmenu =
    awful.menu(
    {
        items = {
            {"awesome", myawesomemenu},
            {"System", system},
            {"Screenshot", screenshot},
            {"Color Picker", gfs.get_configuration_dir() .. "scripts/xcolor-pick"},
            {"Applications", applications},
            {"Kill Application", "xkill"}
        }
    }
)

awful.mouse.append_global_mousebindings(
    {
        awful.button(
            {},
            3,
            function()
                mymainmenu:toggle()
            end
        ),
        awful.button({}, 4, awful.tag.viewprev),
        awful.button({}, 5, awful.tag.viewnext)
    }
)

-- Window Rules
require(... .. ".rules")

-- Notification popup
require(... .. ".notify")

-- Popups
require("popups")

-- Status bar
require(... .. ".wibar")

-- Key bindings
require(... .. ".keybinds")

-- Title bar
require(... .. ".titlebar")
