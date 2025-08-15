local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local helpers = require("helpers")
local gfs = require("gears.filesystem")
local ICON_DIR = gfs.get_configuration_dir() .. "theme/icons/buttons/"

local notifscontainer =
    wibox.widget {
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical,
    forced_height = dpi(900),
    forced_width = dpi(410)
}

local notifsempty =
    wibox.widget {
    nil,
    {
        nil,
        {
            {
                {
                    {
                        widget = wibox.widget.imagebox,
                        image = require "gears".color.recolor_image(
                            gfs.get_configuration_dir() .. "theme/icons/wibar/notifyc.svg",
                            beautiful.yellow
                        ),
                        resize = true,
                        forced_height = dpi(70),
                        forced_width = dpi(70)
                    },
                    widget = wibox.container.place
                },
                nil,
                {
                    markup = helpers.colorizeText("No notifications", beautiful.fg_focus),
                    align = "center",
                    valign = "center",
                    font = beautiful.font_bold,
                    widget = wibox.widget.textbox
                },
                spacing = dpi(10),
                layout = wibox.layout.fixed.vertical
            },
            widget = wibox.container.place
        },
        layout = wibox.layout.align.horizontal
    },
    forced_height = dpi(925), --fix this?
    forced_width = dpi(410),
    layout = wibox.layout.align.vertical
}

local notifsemptyvisible = true

local createnotif = function(n)
    removenotif = function(box)
        notifscontainer:remove_widgets(box)
        if #notifscontainer.children == 0 then
            notifscontainer:insert(1, notifsempty)
            notifsemptyvisible = true
        end
    end
    local notiftitle =
        wibox.widget {
        markup = n.title,
        font = beautiful.font_bold,
        halign = "left",
        widget = wibox.widget.textbox
    }
    local notifboxes =
        wibox.widget {
        {
            {
                {
                    notiftitle,
                    strategy = "exact",
                    width = dpi(300),
                    height = dpi(25),
                    widget = wibox.container.constraint,
                    layout = wibox.layout.align.horizontal,
                    forced_height = dpi(25)
                },
                layout = wibox.layout.align.horizontal
            },
            widget = wibox.container.margin,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(15),
            right = dpi(15),
            forced_width = dpi(300)
        },
        bg = beautiful.altnormal3,
        shape = helpers.rrect(0),
        widget = wibox.container.background
    }
    helpers.addHover(notifboxes, beautiful.altnormal3, beautiful.altnormal3 .. "70")
    local actionsbutton = {
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
                widget = wibox.container.margin,
                top = dpi(0),
                bottom = dpi(0),
                left = dpi(3),
                right = dpi(3)
            },
            shape = helpers.rrect(5),
            forced_height = 35,
            widget = wibox.container.background,
            bg = beautiful.altnormal3
        },
        top = dpi(0),
        left = dpi(5),
        right = dpi(5),
        bottom = dpi(10),
        widget = wibox.container.margin
    }
    local box =
        wibox.widget {
        {
            {
                notifboxes,
                {
                    {
                        {
                            {
                                {
                                    widget = wibox.widget.imagebox,
                                    image = n.icon,
                                    clip_shape = helpers.rrect(8),
                                    align = "right",
                                    resize = true,
                                    resize_strategy = "center"
                                },
                                widget = wibox.container.margin,
                                top = dpi(10),
                                bottom = dpi(10),
                                left = dpi(10),
                                right = dpi(10),
                                forced_height = dpi(10)
                            },
                            {
                                markup = helpers.colorizeText(n.message, beautiful.fg_focus),
                                align = "left",
                                widget = wibox.widget.textbox
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        widget = wibox.container.margin,
                        -- margins = dpi(15),
                        top = dpi(10),
                        bottom = dpi(10),
                        right = dpi(10),
                        forced_height = dpi(90),
                    },
                    widget = wibox.container.background
                },
                {
                    {
                        notification = n,
                        base_layout = wibox.widget {
                            spacing = dpi(0),
                            -- spacing_widget = wibox.widget {
                            -- 	orientation = "horizontal",
                            -- 	widget      = wibox.widget.separator,
                            -- },
                            layout = wibox.layout.flex.horizontal
                            -- widget  = wibox.container.margin,
                            -- right   = dpi(15)
                        },
                        style = {
                            underline_normal = false,
                            underline_selected = false,
                            fg_normal = beautiful.fg_normal,
                            fg_selected = beautiful.fg_normal
                        },
                        widget_template = actionsbutton,
                        style = {underline_normal = false, underline_selected = true},
                        widget = naughty.list.actions
                    },
                    widget = wibox.container.margin,
                    left = dpi(5),
                    right = dpi(5),
                    bottom = dpi(0)
                },
                spacing = dpi(0),
                layout = wibox.layout.fixed.vertical
            },
            margins = dpi(0),
            widget = wibox.container.margin,
            maximum_height = dpi(80)
        },
        bg = beautiful.altnormal2,
        widget = wibox.container.background,
        shape = helpers.rrect(5)
    }
    notifboxes:connect_signal(
        "button::press",
        function(_, _, _, button)
            if button == 1 then
                _G.removenotif(box)
            elseif button == 3 then
                notifscontainer:reset(notifscontainer)
                notifsemptyvisible = true
                notifscontainer:insert(1, notifsempty)
            end
        end
    )
    return box
end

notifscontainer:buttons(
    gears.table.join(
        awful.button(
            {},
            4,
            nil,
            function()
                if #notifscontainer.children == 1 then
                    return
                end
                notifscontainer:insert(1, notifscontainer.children[#notifscontainer.children])
                notifscontainer:remove(#notifscontainer.children)
            end
        ),
        awful.button(
            {},
            5,
            nil,
            function()
                if #notifscontainer.children == 1 then
                    return
                end
                notifscontainer:insert(#notifscontainer.children + 1, notifscontainer.children[1])
                notifscontainer:remove(1)
            end
        )
    )
)

-- Notification center setup

notifscontainer:insert(1, notifsempty)

naughty.connect_signal(
    "request::display",
    function(n)
        if #notifscontainer.children == 1 and notifsemptyvisible then
            notifscontainer:reset(notifscontainer)
            notifsemptyvisible = false
        end

        notifscontainer:insert(1, createnotif(n))
    end
)

local notifs =
    wibox.widget {
    notifscontainer,
    spacing = dpi(0),
    visible = true,
    layout = wibox.layout.fixed.vertical
}

local notifyc =
    awful.popup {
    screen = s,
    widget = wibox.container.background,
    ontop = true,
    bg = beautiful.bg_normal,
    visible = false,
    maximum_width = dpi(425),
    maximum_height = dpi(625),
    placement = function(c)
        awful.placement.bottom_right(
            c,
            {
                margins = {
                    left = dpi(beautiful.widthbar),
                    bottom = dpi(beautiful.widthbar + beautiful.wibar_width),
                    right = dpi(beautiful.widthbar)
                }
            }
        )
    end,
    shape = helpers.rrect(8),
    opacity = 1
}

awesome.connect_signal("widget::notifcenter", function()
	notifyc.visible = not notifyc.visible
  awesome.emit_signal("widget::cal_close")
end)

awesome.connect_signal("widget::notifcenter_close", function()
	notifyc.visible = false
end)

local clearbutton =
    wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorizeText("Clear", beautiful.fg_focus),
            font = beautiful.font_bold,
            align = "center"
        },
        widget = wibox.container.margin,
        top = dpi(0),
        bottom = dpi(0),
        right = dpi(0),
        left = dpi(0),
        forced_width = dpi(100),
        forced_height = dpi(50)
    },
    bg = beautiful.altnormal2,
    shape = helpers.rrect(5),
    widget = wibox.container.background
}

clearbutton:connect_signal(
    "button::press",
    function(_, _, _, button)
        if button == 1 then
            notifscontainer:reset(notifscontainer)
            notifsemptyvisible = true
            notifscontainer:insert(1, notifsempty)
        end
    end
)

helpers.addHover(clearbutton, beautiful.altnormal2, beautiful.altnormal)

local dndicon =
    wibox.widget {
    {
        {
            {
                image = gears.color.recolor_image(ICON_DIR .. "bell.svg", beautiful.fg_focus),
                widget = wibox.widget.imagebox,
                id = "image"
            },
            widget = wibox.container.margin,
            margins = dpi(12.5)
        },
        widget = wibox.container.background
    },
    widget = wibox.container.place,
    valign = "center"
}

local user = require("popups.user_profile")

local dnd =
    wibox.widget {
    {
        {
            {
                dndicon,
                spacing = dpi(0),
                layout = wibox.layout.fixed.vertical
            },
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.background,
    bg = beautiful.altnormal2,
    id = "bg",
    forced_width = dpi(50),
    forced_height = dpi(50),
    shape = helpers.rrect(5)
}

local dnd_on = false
dnd:connect_signal(
    "button::press",
    function()
        dnd_on = not dnd_on
        if dnd_on then
            dnd:get_children_by_id("bg")[1].bg = beautiful.accent
            dndicon:get_children_by_id("image")[1].image =
                gears.color.recolor_image(ICON_DIR .. "bellslash.svg", beautiful.bg_normal)
            user.dnd_status = true
        else
            dnd:get_children_by_id("bg")[1].bg = beautiful.altnormal2
            dndicon:get_children_by_id("image")[1].image =
                gears.color.recolor_image(ICON_DIR .. "bell.svg", beautiful.fg_normal)
            user.dnd_status = false
        end
    end
)

notifyc:setup {
    {
        {
            {
                {
                    {
                        clearbutton,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.horizontal
                    },
                    nil,
                    {
                        dnd,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.horizontal
                    },
                    layout = wibox.layout.align.horizontal
                },
                widget = wibox.container.margin,
                top = dpi(20),
                bottom = dpi(0),
                left = dpi(15),
                right = dpi(15)
            },
            {
                {
                    notifs,
                    layout = wibox.layout.stack
                },
                top = dpi(10),
                left = dpi(15),
                right = dpi(15),
                bottom = dpi(15),
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.vertical
        },
        valign = "bottom",
        layout = wibox.container.place
    },
    shape = helpers.rrect(0),
    widget = wibox.container.background
}

return notifyc
