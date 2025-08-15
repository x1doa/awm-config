local helpers = require("helpers")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gfs = require("gears.filesystem")
local ICON_DIR = gfs.get_configuration_dir() .. "theme/icons/osd"

local osd_box =
    awful.popup {
    screen = s,
    widget = wibox.container.background,
    ontop = true,
    bg = beautiful.bg_normal,
    visible = false,
    placement = function(c)
        awful.placement.bottom(c, {margins = {bottom = dpi(beautiful.widthbar + beautiful.wibar_width), left = dpi(0), right = dpi(0)}})
    end,
    shape = helpers.rrect(5),
    opacity = 1
}

osd_box:setup {
    {
        {
            widget = wibox.widget.imagebox,
            image = require "gears".color.recolor_image(
                ICON_DIR .. "/vol.svg",
                beautiful.fg_focus
            ),
            forced_width = dpi(30),
            forced_height = dpi(30),
            halign = "center",
            valign = "center",
            opacity = 1
        },
        widget = wibox.container.margin,
        left = dpi(15)
    },
    {
        {
            require("modules.volume.slider"),
            widget = wibox.container.margin,
            bottom = dpi(15),
            top = dpi(15),
            left = dpi(5),
            right = dpi(15),
            forced_width = dpi(350),
            forced_height = dpi(60)
        },
        widget = wibox.container.place,
        halign = "center",
        valign = "center",
        layout = wibox.layout.fixed.horizontal
    },
    spacing = dpi(5),
    layout = wibox.layout.fixed.horizontal
}

return osd_box
