-- Load required modules
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local gfs = require("gears.filesystem")
local CONFIG_DIR = gfs.get_configuration_dir()

require "modules.bling".widget.tag_preview.enable {
    show_client_content = false, -- Whether or not to show the client content
    x = dpi(0), -- The x-coord of the popup
    y = dpi(0), -- The y-coord of the popup
    scale = 0.20, -- The scale of the previews compared to the screen
    honor_padding = true, -- Honor padding when creating widget size
    honor_workarea = true, -- Honor work area when creating widget size
    placement_fn = function(c)
        awful.placement.bottom_left(
            c,
            {margins = {bottom = dpi(beautiful.widthbar + beautiful.wibar_width), left = dpi(beautiful.widthbar)}}
        )
    end,
}

screen.connect_signal(
    "request::desktop_decoration",
    function(s)
        awful.tag({"1", "2", "3", "4"}, s, awful.layout.layouts[1])

        local textclock =
            wibox.widget {
            {
                {
                    {
                        wibox.widget.systray(),
                        top = dpi(12.5),
                        bottom = dpi(12.5),
                        right = dpi(0),
                        left = dpi(12.5),
                        widget = wibox.container.margin
                    },
                    require("configuration.wibar.textclock"),
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.horizontal
                },
                widget = wibox.container.margin
            },
            bg = beautiful.altnormal2,
            shape = helpers.rrect(5),
            widget = wibox.container.background
        }

        textclock:connect_signal(
            "mouse::enter",
            function()
                textclock.bg = beautiful.altnormal
                beautiful.bg_systray = beautiful.altnormal
            end
        )
        textclock:connect_signal(
            "mouse::leave",
            function()
                textclock.bg = beautiful.altnormal2
                beautiful.bg_systray = beautiful.altnormal2
            end
        )

        s.mytaglist =
            awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            style = {
                shape = helpers.rrect(5)
            },
            layout = {
                spacing = dpi(5),
                layout = wibox.layout.fixed.horizontal
            },
            widget_template = {
                {
                    {
                        {
                            id = "text_role",
                            widget = wibox.widget.textbox
                        },
                        layout = wibox.layout.fixed.horizontal
                    },
                    top = dpi(10),
                    bottom = dpi(10),
                    left = dpi(12.5),
                    right = dpi(12.5),
                    widget = wibox.container.margin
                },
                id = "background_role",
                widget = wibox.container.background,
                -- Add support for hover colors and an index label
                create_callback = function(self, c3, index, objects) --luacheck: no unused args
                    self:connect_signal(
                        "mouse::enter",
                        function()
                            -- BLING: Only show widget when there are clients in the tag
                            if #c3:clients() > 0 then
                                -- BLING: Update the widget with the new tag
                                awesome.emit_signal("bling::tag_preview::update", c3)
                                -- BLING: Show the widget
                                awesome.emit_signal("bling::tag_preview::visibility", s, true)
                            end
                        end
                    )
                    self:connect_signal(
                        "mouse::leave",
                        function()
                            -- BLING: Turn the widget off
                            awesome.emit_signal("bling::tag_preview::visibility", s, false)
                        end
                    )
                end
            },
            buttons = {
                awful.button({}, 3, awful.tag.viewtoggle),
                awful.button(
                    {},
                    1,
                    function(t)
                        t:view_only()
                    end
                )
            }
        }

        local applauncher =
            wibox.widget {
            {
                wibox.widget {
                    widget = wibox.widget.imagebox,
                    image = require "gears".color.recolor_image(
                        CONFIG_DIR .. "theme/icons/buttons/apps.svg",
                        beautiful.fg_focus
                    ),
                    opacity = 1
                },
                margins = dpi(10),
                widget = wibox.container.margin
            },
            bg = beautiful.altnormal2,
            shape = helpers.rrect(5),
            widget = wibox.container.background
        }

        applauncher:connect_signal(
            "button::press",
            function(_, _, _, button)
                if button == 1 then
                    require("popups.applaunch"):toggle()
                    awesome.emit_signal("widget::notifcenter_close")
                    awesome.emit_signal("widget::cal_close")
                end
            end
        )

        helpers.addHover(applauncher, beautiful.altnormal2, beautiful.altnormal)

        s.mytasklist =
            awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            style = {
                shape = helpers.rrect(5)
            },
            buttons = {
                awful.button(
                    {},
                    1,
                    function(c)
                        c:activate {context = "tasklist", action = "toggle_minimization"}
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.client.focus.byidx(-1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.client.focus.byidx(1)
                    end
                )
            },
            layout = {
                spacing = dpi(5),
                layout = wibox.layout.flex.horizontal
            },
            -- Notice that there is *NO* wibox.wibox prefix, it is a template,
            -- not a widget instance.
            widget_template = {
                {
                    {
                        {
                            {
                                {
                                    id = "icon_role",
                                    widget = wibox.widget.imagebox
                                },
                                top = dpi(10),
                                bottom = dpi(10),
                                left = dpi(10),
                                right = dpi(10),
                                widget = wibox.container.margin
                            },
                            widget = wibox.container.background,
                            bg = beautiful.altnormal,
                            shape = helpers.prrect(5, false, true, true, false)
                        },
                        {
                            {
                                id = "text_role",
                                widget = wibox.widget.textbox
                            },
                            top = dpi(10),
                            bottom = dpi(10),
                            widget = wibox.container.margin
                        },
                        forced_width = awful.screen.focused().geometry.width,
                        spacing = dpi(10),
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = dpi(0),
                    right = dpi(10),
                    widget = wibox.container.margin
                },
                id = "background_role",
                widget = wibox.container.background
            }
        }

        local notifybutton =
            wibox.widget {
            {
                wibox.widget {
                    widget = wibox.widget.imagebox,
                    image = require "gears".color.recolor_image(
                        CONFIG_DIR .. "theme/icons/wibar/notifyc.svg",
                        beautiful.fg_focus
                    ),
                    resize = true,
                    opacity = 1
                },
                margins = dpi(12.5),
                widget = wibox.container.margin
            },
            bg = beautiful.altnormal2,
            shape = helpers.rrect(5),
            widget = wibox.container.background
        }

        local taglist =
            wibox.widget {
            {
                {
                    {
                        s.mytaglist,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.horizontal
                    },
                    top = dpi(5),
                    bottom = dpi(5),
                    left = dpi(5),
                    right = dpi(5),
                    widget = wibox.container.margin
                },
                bg = beautiful.altnormal2,
                shape = helpers.rrect(5),
                widget = wibox.container.background
            },
            top = dpi(0),
            bottom = dpi(0),
            left = dpi(0),
            right = dpi(0),
            widget = wibox.container.margin
        }

        helpers.addHover(notifybutton, beautiful.altnormal2, beautiful.altnormal)

        notifybutton:connect_signal(
            "button::press",
            function(_, _, _, button)
                if button == 1 then
                    awesome.emit_signal("widget::notifcenter")
                end
            end
        )

        s.bottom_panel =
            awful.popup {
            screen = s,
            type = "dock",
            maximum_height = beautiful.wibar_width,
            minimum_width = s.geometry.width,
            maximum_width = s.geometry.width,
            placement = function(c)
                awful.placement.bottom(c)
            end,
            visible = true,
            widget = {
                layout = wibox.layout.align.horizontal,
                {
                    {
                        applauncher,
                        taglist,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.horizontal
                    },
                    top = dpi(7),
                    bottom = dpi(7),
                    left = dpi(7),
                    right = dpi(0),
                    widget = wibox.container.margin
                },
                {
                    {
                        s.mytasklist,
                        halign = "left",
                        layout = wibox.container.place
                    },
                    top = dpi(7),
                    bottom = dpi(7),
                    left = dpi(5),
                    right = dpi(0),
                    widget = wibox.container.margin
                },
                {
                    {
                        {
                            textclock,
                            spacing = dpi(5),
                            layout = wibox.layout.fixed.horizontal
                        },
                        top = dpi(7),
                        bottom = dpi(7),
                        left = dpi(5),
                        right = dpi(0),
                        widget = wibox.container.margin
                    },
                    {
                        notifybutton,
                        top = dpi(7),
                        bottom = dpi(7),
                        left = dpi(5),
                        right = dpi(0),
                        widget = wibox.container.margin
                    },
                    {
                        require("modules.batteryarc")({
                            enable_battery_warning = false,
                            show_current_level = true,
                            size = dpi(beautiful.wibar_width),
                            bg_color = beautiful.altnormal2,
                            arc_thickness = 3,
                            show_notification_mode = 'on_click',
                            main_color = beautiful.fg_focus,
                            charging_color = beautiful.green,
                            font = beautiful.font,
                            notification_position = 'bottom_right',
                            medium_level_color = beautiful.yellow,
                            low_level_color = beautiful.red
                        }),
                        top = dpi(7),
                        bottom = dpi(7),
                        left = dpi(0),
                        right = dpi(0),
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.horizontal
                }
            }
        }
        s.bottom_panel:struts(
            {
                bottom = s.bottom_panel.maximum_height
            }
        )

        --- Remove bottom panel on full screen
        --- It doesn't reappear until full screen application is closed or back to normal mode
        --- Just to prevent fullscreen issue when starting an application in fullscreen mode
        local function remove_bottom_panel(c)
            if c.fullscreen then
                c.screen.bottom_panel.visible = false
            else
                c.screen.bottom_panel.visible = true
            end
        end

        local function add_bottom_panel(c)
            if c.fullscreen then
                c.screen.bottom_panel.visible = true
            end
        end

        --- Hide bar when a splash widget is visible
        awesome.connect_signal(
            "widgets::splash::visibility",
            function(vis)
                screen.primary.bottom_panel.visible = not vis
            end
        )

        client.connect_signal("property::fullscreen", remove_bottom_panel)
        client.connect_signal("request::unmanage", add_bottom_panel)
    end
)
