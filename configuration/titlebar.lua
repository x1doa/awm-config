local awful = require("awful")
local beautiful = require("beautiful")
local gears = require "gears"
local wibox = require "wibox"
local dpi = beautiful.xresources.apply_dpi
local helpers = require "helpers"

client.connect_signal(
    "request::titlebars",
    function(c)
        -- buttons for the titlebar
        local buttons = {
            awful.button(
                {},
                1,
                function()
                    c:activate {context = "titlebar", action = "mouse_move"}
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:activate {context = "titlebar", action = "mouse_resize"}
                end
            )
        }

        local buttons = {
            awful.button(
                {},
                1,
                function()
                    c:activate {context = "titlebar", action = "mouse_move"}
                end
            ),
            awful.button(
                {"Shift"},
                1,
                function()
                    c:activate {context = "titlebar", action = "mouse_resize"}
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:activate {context = "titlebar", action = "mouse_resize"}
                end
            )
        }

        --- Disable popup tooltip on titlebar button hover
        awful.titlebar.enable_tooltip = false

        awful.titlebar(c, {position = "top", size = dpi(40)}).widget = {
            {
                -- Bottom
                {
                    awful.titlebar.widget.iconwidget(c),
                    buttons = buttons,
                    spacing = dpi(5),
                    layout = wibox.layout.fixed.horizontal
                },
                top = dpi(10),
                bottom = dpi(10),
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            {
                -- Center
                {
                    buttons = buttons,
                    spacing = dpi(0),
                    layout = wibox.layout.fixed.horizontal
                },
                top = dpi(0),
                bottom = dpi(0),
                right = dpi(0),
                widget = wibox.container.margin
            },
            {
                -- Top
                {
                    {
                        awful.titlebar.widget.minimizebutton(c),
                        awful.titlebar.widget.maximizedbutton(c),
                        awful.titlebar.widget.closebutton(c),
                        spacing = dpi(0),
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = dpi(5),
                    right = dpi(5),
                    top = dpi(8.5),
                    bottom = dpi(8.5),
                    widget = wibox.container.margin
                },
                widget = wibox.container.rotate,
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

awful.keyboard.append_global_keybindings(
    {
        awful.key(
            {"Mod4"},
            "w",
            function()
                local clients = awful.screen.focused().clients
                for _, c in pairs(clients) do
                    awful.titlebar.toggle(c, "left")
                end
            end,
            {description = "Toggle title bar", group = "awesome"}
        )
    }
)

local function enable_rounding()
    if beautiful.rounded and beautiful.rounded > 0 then
        client.connect_signal(
            "manage",
            function(c, startup)
                if not c.fullscreen and not c.maximized then
                    c.shape = helpers.rrect(beautiful.rounded)
                end
            end
        )

        local function no_round_corners(c)
            if c.fullscreen then
                c.shape = nil
            elseif c.maximized then
                c.shape = gears.shape.rectangle
                c.visible = false
            else
                c.shape = helpers.rrect(beautiful.rounded)
            end
        end

        client.connect_signal("property::fullscreen", no_round_corners)
        client.connect_signal("property::maximized", no_round_corners)

        beautiful.snap_shape = helpers.rrect(beautiful.rounded)
    else
        beautiful.snap_shape = gears.shape.rectangle
    end
end

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

client.connect_signal(
    "request::manage",
    function(c)
        if c.maximized then
            c.x = c.screen.workarea.x
            c.y = c.screen.workarea.y
            c.width = c.screen.workarea.width
            c.height = c.screen.workarea.height
        end
    end
)

-- Prevent fullscreen window cutoff
client.connect_signal(
    "property::fullscreen",
    function(c)
        if c.fullscreen then
            c.floating = true
            c:geometry(screen.primary.geometry)
        else
            c.floating = false
        end
    end
)

client.connect_signal(
    "request::manage",
    function(c)
        --- Add missing icon to client
        if not c.icon then
            local icon = gears.surface(beautiful.theme_assets.awesome_icon(24, beautiful.bluedark, beautiful.black))
            c.icon = icon._native
            icon:finish()
        end

        --- Set the windows at the slave,
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            --- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

enable_rounding()

--- Hide all windows when a splash is shown
awesome.connect_signal(
    "widgets::splash::visibility",
    function(vis)
        local t = screen.primary.selected_tag
        if vis then
            for idx, c in ipairs(t:clients()) do
                c.hidden = true
            end
        else
            for idx, c in ipairs(t:clients()) do
                c.hidden = false
            end
        end
    end
)

-- Window modules
require("modules.better_resize")
require("modules.savefloats")
require("modules.overflow")
