-- Load required modules
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gfs = require("gears.filesystem")

-- Create a buttons and also functionality
local function create_button(img, hover_img, command, hover_color, key)
    local image =
        wibox.widget {
        widget = wibox.widget.imagebox,
        image = gfs.get_configuration_dir() .. "theme/icons/powermenu/" .. img .. ".svg",
        resize = true,
        opacity = 0.8
    }
    local buttons =
        wibox.widget {
        {
            {
                image,
                margins = dpi(30),
                widget = wibox.container.margin
            },
            bg = beautiful.bg_focus .. "d9",
            shape = require("helpers").rrect(100),
            widget = wibox.container.background,
            forced_height = dpi(100),
            forced_width = dpi(100),
            border_width = dpi(0)
        },
        {
            markup = key,
            font = beautiful.font_bold,
            halign = "center",
            widget = wibox.widget.textbox
        },
        spacing = dpi(5),
        layout = wibox.layout.fixed.vertical
    }
    buttons:connect_signal(
        "mouse::enter",
        function()
            buttons.bg = beautiful.bg_focus
            image.image =
                require "gears".color.recolor_image(
                gfs.get_configuration_dir() .. "theme/icons/powermenu/" .. img .. ".svg",
                beautiful.accent
            )
        end
    )
    buttons:connect_signal(
        "mouse::leave",
        function()
            buttons.bg = beautiful.bg_focus .. "d9"
            image.image =
                require "gears".color.recolor_image(
                gfs.get_configuration_dir() .. "theme/icons/powermenu/" .. img .. ".svg",
                beautiful.fg_normal
            )
        end
    )
    buttons:connect_signal(
        "button::press",
        function(_, _, _, button)
            if button == 1 then
                awful.spawn.with_shell(command)
                awesome.emit_signal("powermenu::close")
            end
        end
    )
    return buttons
end

local powermenu_buttons = {
    logout = create_button("logout", "logout", "", beautiful.bg_focus, "[E]xit"),
    reboot = create_button("reboot", "reboot", rebootcmd, beautiful.bg_focus, "[R]eboot"),
    poweroff = create_button("poweroff", "poweroff", poweroffcmd, beautiful.bg_focus, "[P]oweroff"),
    sleep = create_button("sleep", "sleep", suspendcmd, beautiful.bg_focus, "[S]uspend"),
    lock = create_button("lock", "lock", "loginctl lock-session", beautiful.bg_focus, "[L]ock"),
    hibernate = create_button("hibernate", "hibernate", hibernatecmd, beautiful.bg_focus, "[H]ibernate")
}

powermenu_buttons.logout:connect_signal(
    "button::press",
    function(_, _, _, button)
        if button == 1 then
            awesome.quit()
        end
    end
)

return powermenu_buttons
