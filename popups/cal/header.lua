local helpers = require "helpers"
local beautiful = require "beautiful"
local wibox = require "wibox"
local dpi = beautiful.xresources.apply_dpi
local awful = require "awful"
local gears = require "gears"
local gfs = require("gears.filesystem")
local ICON_DIR = gfs.get_configuration_dir() .. "theme/icons/buttons/"

local function update_silent()
    awful.spawn.easy_async_with_shell(
        "sh " .. gfs.get_configuration_dir() .. "scripts/volstatus.sh",
        function(stdout)
            local status = stdout:match("on") -- boolean
            awesome.emit_signal("signal::update_silent", status)
        end
    )
end

gears.timer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function()
        update_silent()
    end
}

awesome.connect_signal(
    "widget::silent",
    function()
        update_silent()
    end
)

local profile_name =
    wibox.widget(
    {
        widget = wibox.widget.textbox,
        markup = "None",
        font = beautiful.font .. "13",
        valign = "center"
    }
)

awful.spawn.easy_async_with_shell(
    [[
		sh -c '
		fullname="$(getent passwd `whoami` | cut -d ':' -f 5 | cut -d ',' -f 1 | tr -d "\n")"
		if [ -z "$fullname" ];
		then
			printf "$(whoami)@$(hostname)"
		else
			printf "$fullname"
		fi
		'
		]],
    function(stdout)
        local stdout = stdout:gsub("%\n", "")
        profile_name:set_markup(stdout)
    end
)

local function update_mic()
    awful.spawn.easy_async_with_shell(
        "sh " .. gfs.get_configuration_dir() .. "scripts/micstatus.sh",
        function(stdout)
            local status = stdout:match("off") -- boolean
            awesome.emit_signal("signal::update_mic", status)
        end
    )
end

gears.timer {
    timeout = 7,
    call_now = true,
    autostart = true,
    callback = function()
        update_mic()
    end
}

awesome.connect_signal(
    "widget::mic",
    function()
        update_mic()
    end
)

local button1 =
    wibox.widget {
    {
        {
            widget = wibox.widget.imagebox,
            image = require "gears".color.recolor_image(
                gfs.get_configuration_dir() .. "theme/icons/powermenu/poweroff.svg",
                beautiful.red
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

helpers.addHover(button1, beautiful.altnormal2, beautiful.altnormal3)

button1:connect_signal(
    "button::press",
    function(_, _, _, button)
        if button == 1 then
            awesome.emit_signal("powermenu::toggle")
        end
    end
)

local colorpicker =
    wibox.widget {
    {
        {
            widget = wibox.widget.imagebox,
            image = require "gears".color.recolor_image(
                gfs.get_configuration_dir() .. "theme/icons/buttons/colorpicker.svg",
                beautiful.green
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

helpers.addHover(colorpicker, beautiful.altnormal2, beautiful.altnormal3)

colorpicker:connect_signal(
    "button::press",
    function(_, _, _, button)
        if button == 1 then
            awful.spawn.with_shell(gfs.get_configuration_dir() .. "/scripts/xcolor-pick")
            awesome.emit_signal("widget::notifcenter_close")
            awesome.emit_signal("widget::cal_close")
        end
    end
)

local silenticon =
    wibox.widget {
    {
        {
            {
                image = gears.color.recolor_image(ICON_DIR .. "speakerslash.svg", beautiful.fg_normal),
                widget = wibox.widget.imagebox,
                id = "image"
            },
            widget = wibox.container.margin,
            margins = dpi(10)
        },
        widget = wibox.container.background
    },
    widget = wibox.container.place,
    valign = "center"
}

local silent =
    wibox.widget {
    {
        {
            {
                silenticon,
                spacing = dpi(0),
                layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.background,
    bg = beautiful.altnormal2,
    id = "bg",
    shape = helpers.rrect(5)
}

silent:connect_signal(
    "button::press",
    function()
        require("awful").spawn.with_shell("amixer set Master toggle")
        update_silent()
    end
)

awesome.connect_signal(
    "signal::update_silent",
    function(val)
        if val then
            silent:get_children_by_id("bg")[1].bg = beautiful.altnormal2
            silenticon:get_children_by_id("image")[1].image =
                gears.color.recolor_image(ICON_DIR .. "speakerslash.svg", beautiful.fg_normal)
        else
            silent:get_children_by_id("bg")[1].bg = beautiful.accent
            silenticon:get_children_by_id("image")[1].image =
                gears.color.recolor_image(ICON_DIR .. "speakerslash.svg", beautiful.bg_normal)
        end
    end
)

local micicon =
    wibox.widget {
    {
        {
            {
                image = gears.color.recolor_image(ICON_DIR .. "micoff.svg", beautiful.bg_normal),
                widget = wibox.widget.imagebox,
                id = "image"
            },
            widget = wibox.container.margin,
            margins = dpi(10)
        },
        widget = wibox.container.background
    },
    widget = wibox.container.place,
    valign = "center"
}

local layoutbox =
    wibox.widget {
    {
        {
            awful.widget.layoutbox,
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.margin
    },
    widget = wibox.container.background
}

local layoutboxbutton =
    wibox.widget {
    {
        layoutbox,
        margins = dpi(10),
        widget = wibox.container.margin
    },
    bg = beautiful.altnormal2,
    shape = helpers.rrect(5),
    widget = wibox.container.background
}

layoutboxbutton:connect_signal(
    "button::press",
    function(_, _, _, button)
        if button == 1 then
            awful.layout.inc(1)
        end
        if button == 3 then
            awful.layout.inc(-1)
        end
    end
)

helpers.addHover(layoutboxbutton, beautiful.altnormal2, beautiful.altnormal)

local mic =
    wibox.widget {
    {
        {
            {
                micicon,
                spacing = dpi(0),
                layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.background,
    bg = beautiful.altnormal2,
    id = "bg",
    shape = helpers.rrect(5)
}

mic:connect_signal(
    "button::press",
    function()
        require("awful").spawn.with_shell("amixer set Capture toggle")
        update_mic()
    end
)

awesome.connect_signal(
    "signal::update_mic",
    function(val)
        if val then
            mic:get_children_by_id("bg")[1].bg = beautiful.accent
            micicon:get_children_by_id("image")[1].image =
                gears.color.recolor_image(ICON_DIR .. "micoff.svg", beautiful.bg_normal)
        else
            mic:get_children_by_id("bg")[1].bg = beautiful.altnormal2
            micicon:get_children_by_id("image")[1].image =
                gears.color.recolor_image(ICON_DIR .. "micoff.svg", beautiful.fg_normal)
        end
    end
)

return wibox.widget {
    {
        {
            {
                {
                    {
                        {
                            {
                                require "modules.pfp",
                                forced_width = dpi(25),
                                forced_height = dpi(25),
                                widget = wibox.container.place
                            },
                            profile_name,
                            spacing = dpi(5),
                            layout = wibox.layout.fixed.horizontal
                        },
                        left = dpi(10),
                        right = dpi(10),
                        widget = wibox.container.margin
                    },
                    bg = beautiful.altnormal2,
                    shape = helpers.rrect(5),
                    widget = wibox.container.background
                },
                margins = dpi(0),
                forced_width = dpi(170),
                widget = wibox.container.margin
            },
            nil,
            {
                layoutboxbutton,
                mic,
                silent,
                colorpicker,
                button1,
                spacing = dpi(5),
                layout = wibox.layout.fixed.horizontal
            },
            layout = wibox.layout.align.horizontal
        },
        top = dpi(0),
        bottom = dpi(0),
        left = dpi(0),
        right = dpi(0),
        forced_height = dpi(40),
        forced_width = dpi(450),
        widget = wibox.container.margin
    },
    layout = wibox.layout.fixed.horizontal
}
