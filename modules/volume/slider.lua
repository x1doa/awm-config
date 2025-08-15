-- Load required modules
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Widget
local volume_slider =
    wibox.widget(
    {
            widget = wibox.widget.slider,
            maximum = 100,
            shape = gears.shape.rounded_bar,
            bar_shape = gears.shape.rounded_bar,
            bar_color = beautiful.altnormal,
            bar_margins = {bottom = dpi(10), top = dpi(10)},
            bar_active_color = beautiful.fg_focus,
            handle_width = dpi(17),
            handle_shape = gears.shape.circle,
            handle_color = beautiful.fg_focus,
            handle_border_width = dpi(1),
            handle_border_color = beautiful.bg_normal,
            value = 0
    }
)

local update_volume_slider = function()
    awful.spawn.easy_async(
        "amixer sget Master",
        function(stdout)
            local volume = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
            volume_slider.value = volume
        end
    )
end

awesome.connect_signal("widget::volume", function()
	update_volume_slider()
end)

local volume_slider_timer =
    gears.timer(
    {
        timeout = 5,
        call_now = true,
        autostart = true,
        callback = update_volume_slider
    }
)

volume_slider:connect_signal(
    "property::value",
    function(slider)
        local volume_level = math.floor(slider.value / 100 * 100)
        awful.spawn("amixer set Master " .. volume_level .. "%")
    end
)

local volume_container = {
    {
        volume_slider,
        widget = wibox.container.margin,
        top = dpi(0),
        bottom = dpi(0),
        right = dpi(0),
        left = dpi(0),
    },
    layout = wibox.layout.fixed.horizontal,
}

return volume_container
