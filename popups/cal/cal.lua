local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local gears = require("gears")
local awful = require("awful")

local calw =
    wibox.widget {
    widget = wibox.widget.calendar.month,
    date = os.date("*t"),
    font = beautiful.font,
    flex_height = true,
    start_sunday = true,
    fn_embed = function(widget, flag, date)
        local focus_widget =
            wibox.widget {
            text = date.day,
            align = "center",
            widget = wibox.widget.textbox,
            {
                bg = beautiful.bg_focus,
                widget = wibox.container.background
            },
            font = beautiful.font_bold
        }
        local torender = flag == "focus" and focus_widget or widget
        if flag == "header" then
            torender.font = beautiful.font_bold
        end
        if flag == "weekday" then
            torender.font = beautiful.font .. "Medium"
        end

        local colors = {
            header = beautiful.fg_normal,
            focus = beautiful.fg_normal,
            normal = beautiful.fg_normal,
            weekday = beautiful.fg_normal
        }
        local bg_colors = {
            focus = beautiful.altnormal2
        }
        local color = colors[flag] or beautiful.fg_normal
        local bg_color = bg_colors[flag] or beautiful.bg_normal .. "00"
        return wibox.widget {
            {
                {
                    torender,
                    align = "center",
                    widget = wibox.container.place
                },
                margins = dpi(11),
                widget = wibox.container.margin
            },
            fg = color,
            bg = bg_color,
            shape = helpers.rrect(5),
            widget = wibox.container.background
        }
    end
}

calw:buttons(
    gears.table.join(
        -- Left Click - Reset date to current date
        awful.button(
            {},
            1,
            function()
                calw.date = os.date "*t"
            end
        ),
        -- Scroll - Move to previous or next month
        awful.button(
            {},
            4,
            function()
                new_calendar_month = calw.date.month - 1
                if new_calendar_month == current_month then
                    calw.date = os.date "*t"
                else
                    calw.date = {month = new_calendar_month, year = calw.date.year}
                end
            end
        ),
        awful.button(
            {},
            5,
            function()
                new_calendar_month = calw.date.month + 1
                if new_calendar_month == current_month then
                    calw.date = os.date "*t"
                else
                    calw.date = {month = new_calendar_month, year = calw.date.year}
                end
            end
        )
    )
)

return wibox.widget {
    {
        {
            calw,
            spacing = dpi(5),
            layout = wibox.layout.fixed.vertical
        },
        widget = wibox.container.margin,
        margins = dpi(0)
    },
    widget = wibox.container.background
}
