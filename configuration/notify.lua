-- Config are taken from https://github.com/Amitabha37377/Awful-DOTS/tree/topbar_dock
-- These code are not made by me, so i modified it

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local ruled = require("ruled")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
local user = require("popups.user_profile")
local dpi = beautiful.xresources.apply_dpi

-- Configuration
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.border_width = dpi(0)
naughty.config.defaults.position = "bottom_right"
naughty.config.defaults.title = "Notification sent!"
naughty.config.defaults.margin = dpi(5)

naughty.connect_signal(
    "request::icon",
    function(n, context, hints)
        if context ~= "app_icon" then
            return
        end

        local path =
            require "menubar".utils.lookup_icon(hints.app_icon) or
            require "menubar".utils.lookup_icon(hints.app_icon:lower())

        if path then
            n.icon = path
        end
    end
)

-- Rules

ruled.notification.connect_signal(
    "request::rules",
    function()
        -- Critical
        ruled.notification.append_rule {
            rule = {urgency = "critical"},
            properties = {
                bg = beautiful.bg_normal,
                fg = beautiful.fg_focus,
                timeout = 10
            }
        }

        -- Normal
        ruled.notification.append_rule {
            rule = {urgency = "normal"},
            properties = {
                bg = beautiful.bg_normal,
                fg = beautiful.fg_normal,
                timeout = 5
            }
        }

        -- Low
        ruled.notification.append_rule {
            rule = {urgency = "low"},
            properties = {
                bg = beautiful.bg_normal,
                fg = beautiful.fg_normal,
                timeout = 5
            }
        }
    end
)

--Actions Template
local actions_template =
    wibox.widget {
    notification = n,
    base_layout = wibox.widget {
        spacing = dpi(3),
        layout = wibox.layout.flex.horizontal
    },
    widget_template = {
        {
            {
                {
                    {
                        id = "text_role",
                        font = beautiful.font_bold,
                        widget = wibox.widget.textbox
                    },
                    widget = wibox.container.place
                },
                widget = wibox.container.background,
                bg = beautiful.altnormal2
            },
            bg = beautiful.groups_bg,
            shape = helpers.rrect(5),
            forced_height = dpi(35),
            widget = wibox.container.background
        },
        margins = dpi(2),
        widget = wibox.container.margin
    },
    style = {underline_normal = false, underline_selected = true},
    widget = naughty.list.actions
}

naughty.connect_signal(
    "request::display",
    function(n)
        local title_n =
            wibox.widget {
            {
                {
                    markup = n.title,
                    font = beautiful.font_bold,
                    align = "left",
                    valign = "center",
                    widget = wibox.widget.textbox
                },
                forced_width = dpi(200),
                widget = wibox.container.scroll.horizontal,
                step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                speed = 50
            },
            margins = {left = dpi(15), right = dpi(15)},
            widget = wibox.container.margin
        }
        local message_n =
            wibox.widget {
            {
                {
                    markup = n.message,
                    font = beautiful.font,
                    align = "left",
                    valign = "center",
                    wrap = "char",
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.fixed.horizontal
            },
            margins = {right = dpi(15)},
            widget = wibox.container.margin
        }
        naughty.layout.box {
            notification = n,
            type = "notification",
            bg = beautiful.bg_normal,
            opacity = 1,
            ontop = true,
            shape = helpers.rrect(5),
            widget_template = {
                {
                    {
                        {
                            {
                                {
                                    {
                                        {
                                            {
                                                title_n,
                                                layout = wibox.layout.fixed.horizontal
                                            },
                                            forced_height = dpi(20),
                                            layout = wibox.layout.align.horizontal
                                        },
                                        left = dpi(0),
                                        right = dpi(10),
                                        top = dpi(15),
                                        bottom = dpi(15),
                                        widget = wibox.container.margin
                                    },
                                    bg = beautiful.altnormal2 .. "80",
                                    widget = wibox.container.background
                                },
                                bottom = dpi(10),
                                widget = wibox.container.margin
                            },
                            strategy = "min",
                            width = dpi(300),
                            widget = wibox.container.constraint
                        },
                        strategy = "max",
                        width = dpi(400),
                        widget = wibox.container.constraint
                    },
                    {
                        {
                            {
                                {
                                    image = n.icon,
                                    resize = true,
                                    clip_shape = helpers.rrect(5),
                                    halign = "center",
                                    valign = "center",
                                    widget = wibox.widget.imagebox
                                },
                                widget = wibox.container.margin,
                                forced_height = dpi(60),
                                top = dpi(0),
                                bottom = dpi(0),
                                left = dpi(12.5),
                                right = dpi(0)
                            },
                            shape = helpers.rrect(5),
                            widget = wibox.container.background
                        },
                        {
                            {
                                {
                                    message_n,
                                    left = dpi(10),
                                    right = dpi(30),
                                    top = dpi(0),
                                    bottom = dpi(0),
                                    widget = wibox.container.margin
                                },
                                strategy = "min",
                                height = dpi(50),
                                widget = wibox.container.constraint
                            },
                            strategy = "max",
                            widget = wibox.container.constraint
                        },
                        layout = wibox.layout.align.horizontal
                    },
                    {
                        actions_template,
                        widget = wibox.container.margin,
                        top = dpi(5),
                        bottom = dpi(10),
                        left = dpi(10),
                        right = dpi(10)
                    },
                    layout = wibox.layout.align.vertical
                },
                id = "background_role",
                widget = naughty.container.background,
                forced_width = dpi(400),
                bg = beautiful.bg_focus
            }
        }
        if user.dnd_status == true then
            naughty.destroy_all_notifications(nil, 1)
        end
    end
)
