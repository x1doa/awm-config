local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gfs = require("gears.filesystem")
local ICON_DIR = gfs.get_configuration_dir()

local cal =
    awful.popup {
    screen = s,
    widget = wibox.container.background,
    ontop = true,
    bg = beautiful.bg_normal,
    visible = false,
    placement = function(c)
        awful.placement.bottom_right(
            c,
            {margins = {left = dpi(beautiful.widthbar), bottom = dpi(beautiful.widthbar + beautiful.wibar_width), right = dpi(beautiful.widthbar)}}
        )
    end,
    shape = helpers.rrect(5),
    opacity = 1
}

awesome.connect_signal("widget::cal", function()
	cal.visible = not cal.visible
  awesome.emit_signal("widget::notifcenter_close")
end)

awesome.connect_signal("widget::cal_close", function()
	cal.visible = false
end)

local calw = require(... .. ".cal")
cal:setup {
    {
        {
            calw,
        {
            {
                {
                    {
                        {
                            {
                                widget = wibox.widget.imagebox,
                                image = require "gears".color.recolor_image(
                                    ICON_DIR .. "theme/icons/osd/backlight.svg",
                                    beautiful.fg_focus
                                ),
                                forced_width = dpi(30),
                                forced_height = dpi(30),
                                halign = "center",
                                valign = "center",
                                opacity = 1
                            },
                            widget = wibox.container.margin,
                            right = dpi(10)
                        },
                        require("modules.brightness"),
                        forced_height = dpi(30),
                        layout = wibox.layout.fixed.horizontal
                    },
                    widget = wibox.container.margin,
                    margins = dpi(15)
                },
                bg = beautiful.altnormal2,
                shape = helpers.rrect(5),
                widget = wibox.container.background
            },
            widget = wibox.container.margin,
            top = dpi(5),
            bottom = dpi(0),
            right = dpi(0),
            left = dpi(0)
        },
        {
            {
                {
                    {
                        {
                            {
                                widget = wibox.widget.imagebox,
                                image = require "gears".color.recolor_image(
                                    ICON_DIR .. "theme/icons/osd/vol.svg",
                                    beautiful.fg_focus
                                ),
                                forced_width = dpi(30),
                                forced_height = dpi(30),
                                halign = "center",
                                valign = "center",
                                opacity = 1
                            },
                            widget = wibox.container.margin,
                            right = dpi(10)
                        },
                        require("modules.volume.slider"),
                        forced_height = dpi(30),
                        layout = wibox.layout.fixed.horizontal
                    },
                    widget = wibox.container.margin,
                    margins = dpi(15)
                },
                bg = beautiful.altnormal2,
                shape = helpers.rrect(5),
                widget = wibox.container.background
            },
            widget = wibox.container.margin,
            top = dpi(0),
            bottom = dpi(0),
            right = dpi(0),
            left = dpi(0)
        },
        {
            {
                {
                    {
                        {
                            {
                                widget = wibox.widget.imagebox,
                                image = require "gears".color.recolor_image(
                                    ICON_DIR .. "theme/icons/osd/mic.svg",
                                    beautiful.fg_focus
                                ),
                                forced_width = dpi(30),
                                forced_height = dpi(30),
                                halign = "center",
                                valign = "center",
                                opacity = 1
                            },
                            widget = wibox.container.margin,
                            right = dpi(10)
                        },
                        require("modules.volume.mic-slider"),
                        forced_height = dpi(30),
                        layout = wibox.layout.fixed.horizontal
                    },
                    widget = wibox.container.margin,
                    margins = dpi(15)
                },
                bg = beautiful.altnormal2,
                shape = helpers.rrect(5),
                widget = wibox.container.background
            },
            widget = wibox.container.margin,
            top = dpi(0),
            bottom = dpi(0),
            right = dpi(0),
            left = dpi(0)
        },
            require(... .. ".header"),
            spacing = dpi(5),
            layout = wibox.layout.fixed.vertical
        },
        widget = wibox.container.margin,
        margins = dpi(15)
    },
    forced_width = 425,
    widget = wibox.container.background,
}
return cal
