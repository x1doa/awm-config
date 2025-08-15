local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi
local bling = require "modules.bling"
local helpers = require "helpers"
local awful = require "awful"

local args = {
    apps_per_column = 5,
    apps_per_row = 3,
    sort_alphabetically = false,
    shape = helpers.rrect(5),
    prompt_font = beautiful.font,
    icon_size = dpi(40),
    prompt_height = dpi(60),
    prompt_icon = "",
    type = "dock",
    app_selected_color = beautiful.altnormal2,
    app_name_selected_color = beautiful.fg_focus,
    prompt_show_icon = false,
    prompt_margins = dpi(0),
    prompt_paddings = dpi(20),
    reverse_sort_alphabetically = true,
    placement = function(c)
        awful.placement.bottom_left(c, {margins = {bottom = dpi(beautiful.widthbar + beautiful.wibar_width), left = dpi(beautiful.widthbar), right = dpi(0)}})
    end,        
}

local app_launcher = bling.widget.app_launcher(args)

return app_launcher
