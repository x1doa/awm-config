-- Textclock widget
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local calendar = require("popups.cal")
local helpers = require("helpers")

local textclock1 =
    wibox.widget {
    {
        font = beautiful.font,
        format = "<b>" .. helpers.colorizeText("%a", beautiful.accent) .. "</b>" .. " %I:%M " .. helpers.colorizeText("%p", beautiful.fg_normal),
        widget = wibox.widget.textclock
    },
    widget = wibox.container.place,
    valign = "center"
}

local textclock =
    wibox.widget {
    {
        textclock1,
        spacing = dpi(0),
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    top = dpi(0),
    bottom = dpi(0),
    left = dpi(0),
    right = dpi(15)
}

textclock:connect_signal(
    "button::press",
    function(_, _, _, button)
        if button == 1 then
            awesome.emit_signal("widget::cal")
        end
    end
)

return textclock
