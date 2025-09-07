-- Load required modules
local awful = require("awful")
local gears = require("gears")
local bling = require("modules.bling")
require("awful.hotkeys_popup.keys")
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers.extras")

-- Load required custom modules
local hotkeys_popup = require("awful.hotkeys_popup")
local osd = require("popups.osds")
local osdv = require("popups.osds.vol")
local ll = require("popups.layoutlist")
local powermenu = require("popups.powermenu")

bling.widget.window_switcher.enable {
    type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews
    -- keybindings (the examples provided are also the default if kept unset)
    hide_window_switcher_key = "Escape", -- The key on which to close the popup
    minimize_key = "n", -- The key on which to minimize the selected client
    unminimize_key = "N", -- The key on which to unminimize all clients
    kill_client_key = "q", -- The key on which to close the selected client
    cycle_key = "Tab", -- The key on which to cycle through all clients
    previous_key = "Left", -- The key on which to select the previous client
    next_key = "Right", -- The key on which to select the next client
    vim_previous_key = "h", -- Alternative key on which to select the previous client
    vim_next_key = "l", -- Alternative key on which to select the next client
    cycleClientsByIdx = awful.client.focus.byidx, -- The function to cycle the clients
    filterClients = awful.widget.tasklist.filter.currenttags -- The function to filter the viewed clients
}

-- Timer
local timer =
    gears.timer {
    timeout = 2,
    autostart = true,
    callback = function()
        osd.visible = false
        osdv.visible = false
        ll.visible = false
    end
}

-- Attach the timer to a signal that triggers when the mouse enters the dock
osd:connect_signal(
    "mouse::enter",
    function()
        timer:stop() -- Stop the timer when the mouse enters the dock
        osd.visible = true -- Show the dock immediately
    end
)

ll:connect_signal(
    "mouse::enter",
    function()
        timer:stop() -- Stop the timer when the mouse enters the dock
        ll.visible = true -- Show the dock immediately
    end
)

-- Attach the timer to a signal that triggers when the mouse leaves the dock
osd:connect_signal(
    "mouse::leave",
    function()
        timer:again() -- Restart the timer when the mouse leaves the dock
    end
)

-- Attach the timer to a signal that triggers when the mouse leaves the dock
ll:connect_signal(
    "mouse::leave",
    function()
        timer:again() -- Restart the timer when the mouse leaves the dock
    end
)

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Ccontrol = require "popups.control_center"ontrol and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"
ctrl = "Control"
shift = "Shift"

-----------------
-- KEYBINDINGS --
-----------------

-- General Awesome keys
awful.keyboard.append_global_keybindings(
    {
        awful.key({modkey}, "F1", hotkeys_popup.show_help, {description = "Toggle hotkeys popup", group = "client"}),
        awful.key({modkey, "Control"}, "r", awesome.restart, {description = "Reload an config", group = "awesome"}),
        awful.key(
            {modkey},
            "Return",
            function()
                awful.spawn(terminal)
            end,
            {description = "Open a terminal", group = "awesome"}
        ),
        awful.key(
            {modkey, "Ctrl"},
            "q",
            function()
                awesome.quit()
            end,
            {description = "Quit awesome", group = "awesome"}
        ),
        awful.key(
            {},
            "Print",
            function()
                awful.spawn("flameshot screen")
            end,
            {description = "Take an screenshot", group = "screenshot"}
        ),
        awful.key(
            {modkey},
            "Print",
            function()
                awful.spawn("flameshot gui")
            end,
            {description = "Take an manual screenshot", group = "screenshot"}
        ),
        awful.key(
            {modkey, "Mod1"},
            "n",
            function()
                awesome.emit_signal("widget::notifcenter")               
            end,
            {description = "Open notification center", group = "awesome"}
        ),
        awful.key(
            {modkey, "Mod1"},
            "c",
            function()
                awesome.emit_signal("widget::cal") 
            end,
            {description = "Open calendar popup", group = "awesome"}
        ),
        awful.key(
            {"Mod1"},
            "Tab",
            function()
                awesome.emit_signal("bling::window_switcher::turn_on")
            end,
            {description = "Window Switcher", group = "bling"}
        ),
        awful.key(
            {"Ctrl", "Mod1"},
            "a",
            function()
                bling.module.tabbed.pick()
            end,
            {description = "Picks a client with your cursor to add to the tabbing group", group = "bling"}
        ),
        awful.key(
            {"Mod1"},
            "a",
            function()
                bling.module.tabbed.pick_with_dmenu()
            end,
            {description = "Picks a client to add to tab group", group = "bling"}
        ),
        awful.key(
            {"Mod1", "Shift"},
            "space",
            function()
                bling.module.tabbed.pop()
            end,
            {description = "Removes the focused client from the tabbing group", group = "bling"}
        ),
        awful.key(
            {"Mod1", "Shift"},
            "t",
            function()
                bling.module.tabbed.iter()
            end,
            {description = "Iterates through the currently focused tabbing group", group = "bling"}
        ),
        awful.key(
            {modkey, "Shift"},
            "o",
            function()
                awful.spawn.with_shell(require 'gears.filesystem'.get_configuration_dir() .. "scripts/xcolor-pick")
            end,
            {description = "Pick an color", group = "other"}
        ),
        awful.key(
            {modkey, "Shift"},
            "i",
            function()
                awful.spawn.with_shell("redshift-toggle")
            end,
            {description = "Toggle Redshift", group = "other"}
        ),
        awful.key(
            {modkey},
            "p",
            function()
                require("popups.applaunch"):toggle()
                require 'popups.cal'.visible = false
                require 'popups.notif_center'.visible = false
            end,
            {description = "App Launcher", group = "awesome"}
        ),
        awful.key {
            modifiers = {},
            key = "XF86MonBrightnessUp",
            description = "Increase the brightness by 5%",
            group = "volume and brightness",
            on_press = function()
                awful.spawn("light -A 20")
                osd.visible = true
                awesome.emit_signal("widget::brightness")
                timer:again()
            end
        },
        awful.key {
            modifiers = {},
            key = "XF86MonBrightnessDown",
            description = "Decrease the brightness by 5%",
            group = "volume and brightness",
            on_press = function()
                awful.spawn("light -U 20")
                osd.visible = true
                awesome.emit_signal("widget::brightness")
                timer:again()
            end
        },
        awful.key {
            modifiers = {},
            key = "XF86AudioRaiseVolume",
            description = "Increase the volume by 5%",
            group = "volume and brightness",
            on_press = function()
                awful.spawn("amixer set Master 5%+")
                osdv.visible = true
                awesome.emit_signal("widget::volume")
                awesome.emit_signal("widget::mic")
                timer:again()
            end
        },
        awful.key {
            modifiers = {"Ctrl", "Mod1"},
            key = "Delete",
            description = "Bring the power menu",
            group = "awesome",
            on_press = function()
                awesome.emit_signal("powermenu::toggle")
            end
        },
        awful.key {
            modifiers = {},
            key = "XF86AudioLowerVolume",
            description = "Decrease the volume by 5%",
            group = "volume and brightness",
            on_press = function()
                awful.spawn("amixer set Master 5%-")
                awesome.emit_signal("widget::volume")
                awesome.emit_signal("widget::mic")
                osdv.visible = true
                timer:again()
            end
        },
        awful.key {
            modifiers = {},
            key = "XF86AudioMute",
            description = "Mute a volume",
            group = "volume and brightness",
            on_press = function()
                awful.spawn("amixer -q set Master toggle")
                awesome.emit_signal("widget::mic")
                awesome.emit_signal("widget::volume")
                awesome.emit_signal("widget::silent")
            end
        },
        awful.key {
            modifiers = {},
            key = "XF86AudioMicMute",
            description = "Mute a microphone volume",
            group = "volume and brightness",
            on_press = function()
                awful.spawn("amixer -q set Capture toggle")
                awesome.emit_signal("widget::mic")
                awesome.emit_signal("widget::volume")
                awesome.emit_signal("widget::silent")
            end
        },
        awful.key {
            modifiers = {},
            key = "XF86AudioPlay",
            description = "Toggle play/pause",
            group = "player control",
            on_press = function()
                awful.spawn("playerctl play-pause")
            end
        },
        awful.key {
            modifiers = {},
            key = "XF86AudioNext",
            description = "Skip to the next track",
            group = "player control",
            on_press = function()
                awful.spawn("playerctl next")
            end
        },
        awful.key {
            modifiers = {},
            key = "XF86AudioPrev",
            description = "Skip to the previous track",
            group = "player control",
            on_press = function()
                awful.spawn("playerctl previous")
            end
        }
    }
)

-- Tags related keybindings
awful.keyboard.append_global_keybindings(
    {
        awful.key({modkey}, "Left", awful.tag.viewprev, {description = "View previous", group = "tag"}),
        awful.key({modkey}, "Right", awful.tag.viewnext, {description = "View next", group = "tag"}),
        awful.key({modkey}, "Escape", awful.tag.history.restore, {description = "Go back", group = "tag"})
    }
)

-- Focus related keybindings
awful.keyboard.append_global_keybindings(
    {
        awful.key(
            {modkey},
            "k",
            function()
                awful.client.focus.bydirection("up")
                bling.module.flash_focus.flashfocus(client.focus)
            end,
            {description = "focus up", group = "client"}
        ),
        awful.key(
            {modkey},
            "j",
            function()
                awful.client.focus.bydirection("down")
                bling.module.flash_focus.flashfocus(client.focus)
            end,
            {description = "focus down", group = "client"}
        ),
        awful.key(
            {modkey},
            "h",
            function()
                awful.client.focus.bydirection("left")
                bling.module.flash_focus.flashfocus(client.focus)
            end,
            {description = "focus left", group = "client"}
        ),
        awful.key(
            {modkey},
            "l",
            function()
                awful.client.focus.bydirection("right")
                bling.module.flash_focus.flashfocus(client.focus)
            end,
            {description = "focus right", group = "client"}
        ),
        awful.key(
            {modkey, "Shift"},
            "c",
            function()
                awful.spawn.with_shell("xkill")
            end,
            {description = "Kill applications using xkill", group = "client"}
        ),
        awful.key(
            {modkey},
            "Tab",
            function()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "Go back", group = "client"}
        ),
        awful.key(
            {modkey, "Mod1"},
            "j",
            function()
                awful.screen.focus_relative(1)
            end,
            {description = "Focus the next screen", group = "screen"}
        ),
        awful.key(
            {modkey, "Mod1"},
            "k",
            function()
                awful.screen.focus_relative(-1)
            end,
            {description = "Focus the previous screen", group = "screen"}
        ),
        awful.key(
            {modkey, "Control"},
            "n",
            function()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    c:activate {raise = true, context = "key.unminimize"}
                end
            end,
            {description = "restore minimized", group = "client"}
        )
    }
)

-- Layout related keybindings
awful.keyboard.append_global_keybindings(
    {
        awful.key(
            {modkey, "Shift"},
            "j",
            function()
                awful.client.swap.byidx(1)
            end,
            {description = "Swap with next client by index", group = "client"}
        ),
        awful.key(
            {modkey, "Shift"},
            "k",
            function()
                awful.client.swap.byidx(-1)
            end,
            {description = "Swap with previous client by index", group = "client"}
        ),
        awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "Jump to urgent client", group = "client"}),
        awful.key(
            {modkey, "Shift"},
            "h",
            function()
                awful.tag.incnmaster(1, nil, true)
            end,
            {description = "Increase the number of master clients", group = "layout"}
        ),
        awful.key(
            {modkey, "Shift"},
            "l",
            function()
                awful.tag.incnmaster(-1, nil, true)
            end,
            {description = "Decrease the number of master clients", group = "layout"}
        ),
        awful.key(
            {modkey, "Mod1"},
            "h",
            function()
                awful.tag.incncol(1, nil, true)
            end,
            {description = "Increase the number of columns", group = "layout"}
        ),
        awful.key(
            {modkey, "Mod1"},
            "l",
            function()
                awful.tag.incncol(-1, nil, true)
            end,
            {description = "Decrease the number of columns", group = "layout"}
        ),
        awful.key(
            {modkey},
            "space",
            function()
                awful.layout.inc(1)
                ll.visible = true
                timer:again()
            end,
            {description = "Select next", group = "layout"}
        ),
        awful.key(
            {modkey, "Shift"},
            "space",
            function()
                awful.layout.inc(-1)
                ll.visible = true
                timer:again()
            end,
            {description = "Select previous", group = "layout"}
        )
    }
)

-- @DOC_NUMBER_KEYBINDINGS@

awful.keyboard.append_global_keybindings(
    {
        awful.key {
            modifiers = {modkey},
            keygroup = "numrow",
            description = "Only view tag",
            group = "tag",
            on_press = function(index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then
                    tag:view_only()
                end
            end
        },
        awful.key {
            modifiers = {modkey, "Control"},
            keygroup = "numrow",
            description = "Toggle tag",
            group = "tag",
            on_press = function(index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end
        },
        awful.key {
            modifiers = {modkey, "Shift"},
            keygroup = "numrow",
            description = "Move focused client to tag",
            group = "tag",
            on_press = function(index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end
        },
        awful.key {
            modifiers = {modkey, "Control", "Shift"},
            keygroup = "numrow",
            description = "Toggle focused client on tag",
            group = "tag",
            on_press = function(index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end
        },
        awful.key {
            modifiers = {modkey},
            keygroup = "numpad",
            description = "Select layout directly",
            group = "layout",
            on_press = function(index)
                local t = awful.screen.focused().selected_tag
                if t then
                    t.layout = t.layouts[index] or t.layout
                end
            end
        }
    }
)

-- @DOC_CLIENT_BUTTONS@
client.connect_signal(
    "request::default_mousebindings",
    function()
        awful.mouse.append_client_mousebindings(
            {
                awful.button(
                    {},
                    1,
                    function(c)
                        c:activate {context = "mouse_click"}
                    end
                ),
                awful.button(
                    {modkey},
                    1,
                    function(c)
                        c:activate {context = "mouse_click", action = "mouse_move"}
                    end
                ),
                awful.button(
                    {modkey},
                    3,
                    function(c)
                        c:activate {context = "mouse_click", action = "mouse_resize"}
                    end
                )
            }
        )
    end
)

-- @DOC_CLIENT_KEYBINDINGS@
client.connect_signal(
    "request::default_keybindings",
    function()
        awful.keyboard.append_client_keybindings(
            {
                --- Resize focused client
                awful.key(
                    {modkey, ctrl},
                    "k",
                    function(c)
                        helpers.client.resize_client(client.focus, "up")
                    end,
                    {description = "Resize to the up", group = "client"}
                ),
                awful.key(
                    {modkey, ctrl},
                    "j",
                    function(c)
                        helpers.client.resize_client(client.focus, "down")
                    end,
                    {description = "Resize to the down", group = "client"}
                ),
                awful.key(
                    {modkey, ctrl},
                    "h",
                    function(c)
                        helpers.client.resize_client(client.focus, "left")
                    end,
                    {description = "Resize to the left", group = "client"}
                ),
                awful.key(
                    {modkey, ctrl},
                    "l",
                    function(c)
                        helpers.client.resize_client(client.focus, "right")
                    end,
                    {description = "Resize to the right", group = "client"}
                ),
                awful.key(
                    {modkey, ctrl},
                    "Up",
                    function(c)
                        helpers.client.resize_client(client.focus, "up")
                    end,
                    {description = "Resize to the up", group = "client"}
                ),
                awful.key(
                    {modkey, ctrl},
                    "Down",
                    function(c)
                        helpers.client.resize_client(client.focus, "down")
                    end,
                    {description = "Resize to the down", group = "client"}
                ),
                awful.key(
                    {modkey, ctrl},
                    "Left",
                    function(c)
                        helpers.client.resize_client(client.focus, "left")
                    end,
                    {description = "Resize to the left", group = "client"}
                ),
                awful.key(
                    {modkey, ctrl},
                    "Right",
                    function(c)
                        helpers.client.resize_client(client.focus, "right")
                    end,
                    {description = "Resize to the right", group = "client"}
                ),
                --- On the fly padding change
                awful.key(
                    {modkey, shift},
                    "=",
                    function()
                        helpers.client.resize_padding(5)
                    end,
                    {description = "Add padding", group = "layout"}
                ),
                awful.key(
                    {modkey, shift},
                    "-",
                    function()
                        helpers.client.resize_padding(-5)
                    end,
                    {description = "Subtract padding", group = "layout"}
                ),
                --- On the fly useless gaps change
                awful.key(
                    {modkey},
                    "=",
                    function()
                        helpers.client.resize_gaps(5)
                    end,
                    {description = "Add gaps", group = "layout"}
                ),
                awful.key(
                    {modkey},
                    "-",
                    function()
                        helpers.client.resize_gaps(-5)
                    end,
                    {description = "Subtract gaps", group = "layout"}
                ),
                --- Relative move client
                awful.key(
                    {modkey, shift, ctrl},
                    "j",
                    function(c)
                        c:relative_move(0, dpi(20), 0, 0)
                    end
                ),
                awful.key(
                    {modkey, shift, ctrl},
                    "k",
                    function(c)
                        c:relative_move(0, dpi(-20), 0, 0)
                    end
                ),
                awful.key(
                    {modkey, shift, ctrl},
                    "h",
                    function(c)
                        c:relative_move(dpi(-20), 0, 0, 0)
                    end
                ),
                awful.key(
                    {modkey, shift, ctrl},
                    "l",
                    function(c)
                        c:relative_move(dpi(20), 0, 0, 0)
                    end
                ),
                awful.key(
                    {modkey},
                    "f",
                    function(c)
                        c.fullscreen = not c.fullscreen
                        c:raise()
                    end,
                    {description = "Toggle client to fullscreen", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "q",
                    function(c)
                        c:kill()
                    end,
                    {description = "close", group = "client"}
                ),
                awful.key(
                    {modkey, "Mod1"},
                    "space",
                    awful.client.floating.toggle,
                    {description = "Toggle client to floating", group = "client"}
                ),
                awful.key(
                    {modkey, "Control"},
                    "Return",
                    function(c)
                        c:swap(awful.client.getmaster())
                    end,
                    {description = "Move to master", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "o",
                    function(c)
                        c:move_to_screen()
                    end,
                    {description = "Move to screen", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "t",
                    function(c)
                        c.ontop = not c.ontop
                    end,
                    {description = "Toggle keep on top", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "n",
                    function(c)
                        -- The client currently has the input focus, so it cannot be
                        -- minimized, since minimized clients can't have the focus.
                        c.minimized = true
                    end,
                    {description = "Minimize", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "m",
                    function(c)
                        c.maximized = not c.maximized
                        c:raise()
                    end,
                    {description = "(Un)maximize", group = "client"}
                ),
                awful.key(
                    {modkey, "Control"},
                    "m",
                    function(c)
                        c.maximized_vertical = not c.maximized_vertical
                        c:raise()
                    end,
                    {description = "(Un)maximize vertically", group = "client"}
                ),
                awful.key(
                    {modkey, "Shift"},
                    "m",
                    function(c)
                        c.maximized_horizontal = not c.maximized_horizontal
                        c:raise()
                    end,
                    {description = "(Un)maximize horizontally", group = "client"}
                )
            }
        )
    end
)
