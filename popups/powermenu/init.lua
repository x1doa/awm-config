-- Load required modules, and also other stuffs
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local buttons = require("popups.powermenu.buttons")
local gears = require "gears"

local back2 =
    wibox.widget {
    bg = beautiful.bg_normal .. "60",
    widget = wibox.container.background,
    forced_height = awful.screen.focused().geometry.height,
    forced_width = awful.screen.focused().geometry.width
}

local time =
    wibox.widget {
    {
        font = beautiful.font .. "Light 20",
        widget = wibox.widget.textclock("%I:%M %p")
    },
    widget = wibox.container.place,
    valign = "center"
}

-- Separator widget
local separator = wibox.widget.textbox("    ")
separator.forced_height = dpi(0)
separator.forced_width = dpi(1)

local powermenu =
    awful.popup {
    screen = s,
    widget = wibox.container.background,
    ontop = true,
    type = "splash",
    bg = "#000000" .. "80",
    visible = false,
    placement = function(c)
        awful.placement.maximize(c, {margins = {top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0)}})
    end,
    opacity = 1
}

-- {{
-- Code was taken from: https://github.com/raven2cz/awesomewm-config and modified it.
-- Not made by me.

local exit_actions = {
    ["poweroff"] = function()
        awful.spawn.with_shell(poweroffcmd)
    end,
    ["reboot"] = function()
        awful.spawn.with_shell(rebootcmd)
    end,
    ["suspend"] = function()
        awful.spawn.with_shell(suspendcmd)
    end,
    ["exit"] = function()
        awesome.quit()
    end,
    ["lock"] = function()
        awful.spawn.with_shell("loginctl lock-session")
    end,
    ["hibernate"] = function()
        awful.spawn.with_shell(hibernatecmd)
    end
}

local function getKeygrabber()
    return awful.keygrabber {
        keypressed_callback = function(_, mod, key)
            if key == "p" then
                exit_actions["poweroff"]()
                awesome.emit_signal("powermenu::close")
            elseif key == "r" then
                exit_actions["reboot"]()
                awesome.emit_signal("powermenu::close")
            elseif key == "h" then
                exit_actions["hibernate"]()
                awesome.emit_signal("powermenu::close")
            elseif key == "s" then
                exit_actions["suspend"]()
                awesome.emit_signal("powermenu::close")
            elseif key == "e" then
                exit_actions["exit"]()
                awesome.emit_signal("powermenu::close")
            elseif key == "l" then
                exit_actions["lock"]()
                awesome.emit_signal("powermenu::close")
            elseif key == exitKey or key == "q" or key == "x" then
                awesome.emit_signal("powermenu::close")
            end
        end
    }
end

powermenu_grabber = getKeygrabber()

powermenu.signals_on = function()
    -- Get new screen geometry
    s = awful.screen.focused()
    geo_x = s.geometry.x
    geo_y = s.geometry.y
    geo_width = s.geometry.width
    geo_height = s.geometry.height

    -- Update the widget
    powermenu.screen = s
    powermenu.x = geo_x
    powermenu.y = geo_y
    powermenu.height = geo_height
    powermenu.width = geo_width

    powermenu_grabber:start()
end

powermenu.signals_off = function()
    powermenu_grabber:stop()
end

powermenu.close = function()
    powermenu.visible = false
    powermenu.signals_off()
end

powermenu.toggle = function()
    awesome.emit_signal("widget::cal_close")
    awesome.emit_signal("widget::notifcenter_close")
    powermenu.visible = not powermenu.visible
    if powermenu.visible then
        powermenu_grabber = getKeygrabber()
        powermenu.signals_on()
        awesome.emit_signal("powermenu::open")
    else
        powermenu.signals_off()
    end
end

powermenu:buttons(
    gears.table.join(
        -- Middle click - Hide powermenu
        awful.button(
            {},
            2,
            function()
                awesome.emit_signal("powermenu::close")
            end
        ),
        -- Right click - Hide powermenu
        awful.button(
            {},
            3,
            function()
                awesome.emit_signal("powermenu::close")
            end
        )
    )
)

-- listen to signal emitted by other widgets
awesome.connect_signal("powermenu::toggle", powermenu.toggle)
awesome.connect_signal("powermenu::close", powermenu.close)

-- switch off signals after start, just read once only!
powermenu.signals_off()

-- }}

local powerbutton = {
    buttons.poweroff,
    buttons.reboot,
    buttons.logout,
    buttons.sleep,
    buttons.lock,
    buttons.hibernate,
    spacing = dpi(10),
    layout = wibox.layout.fixed.horizontal
}

local powerscreenbutton =
    wibox.widget {
    {
        {
            {
                {
                    powerbutton,
                    widget = wibox.layout.fixed.horizontal
                },
                spacing = dpi(10),
                layout = wibox.layout.fixed.vertical
            },
            widget = wibox.container.margin,
            margins = dpi(0)
        },
        widget = wibox.container.background
    },
    layout = wibox.layout.fixed.vertical
}

powermenu:setup {
    back2,
    {
        separator,
        {
            {
                {
                    powerscreenbutton,
                    layout = wibox.layout.fixed.vertical
                },
                layout = wibox.container.place,
                valign = "center",
                halign = "center"
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(20)
        },
        layout = wibox.layout.align.vertical,
        expand = "none"
    },
    layout = wibox.layout.stack
}

return powermenu
