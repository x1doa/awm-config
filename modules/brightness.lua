-- Load required modules
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Widget
local brightness_slider =
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

local update_brightness_slider = function()
    awful.spawn.easy_async(
        "light -G",
        function(stdout)
            local brightness = tonumber(stdout)
            brightness_slider.value = brightness
        end
    )
end

local brightness_slider_timer =
    gears.timer(
    {
        timeout = 8,
        call_now = true,
        autostart = true,
        callback = update_brightness_slider
    }
)

awesome.connect_signal("widget::brightness", function()
	update_brightness_slider()
end)


brightness_slider:connect_signal(
    "property::value",
    function(slider)
        local brightness_level = math.floor(slider.value / 100 * 100)
        awful.spawn.easy_async(
            "light -S " .. brightness_level,
            function()
            end
        )
    end
)

local brightness_container = {
    {
        brightness_slider,
        widget = wibox.container.margin,
        top = dpi(0),
        bottom = dpi(0),
        right = dpi(0),
        left = dpi(0),
    },
    layout = wibox.layout.fixed.horizontal,
}

return brightness_container
