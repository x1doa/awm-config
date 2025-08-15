local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require "gears"
local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir() .. "theme/"
local titlebar_assets_path = gfs.get_configuration_dir() .. "theme/titlebar/"
local theme = {}

-- Colors and other settings
theme.blue = "#5b9bf8"
theme.bluedark = "#1a5fb4"
theme.yellow = "#f8e45c"
theme.green = "#57e389"
theme.magenta = "#9141ac"
theme.red = "#f66151"
theme.altnormal = "#2f2f2f"
theme.altnormal2 = "#181818"
theme.altnormal3 = "#1f1f1f"
theme.altfocus = "#2b2b2b"
theme.font = "Inter "
theme.font_bold = theme.font .. "Bold "
theme.tasklist_font = theme.font_bold
theme.tasklist_plain_task_name = true
theme.titlebar_bg_normal = "#101010"
theme.titlebar_bg_focus = "#121212"
theme.titlebar_bg_urgent = "#ff7043"
theme.bg_normal = "#0f0f0f"
theme.bg_focus = "#161616"
theme.bg_urgent = theme.titlebar_bg_urgent
theme.bg_minimize = theme.altnormal2
theme.fg_normal = "#f2f2f2"
theme.fg_focus = "#ffffff"
theme.fg_urgent = theme.bg_focus
theme.fg_minimize = theme.bg_focus
theme.useless_gap = dpi(2)
theme.menu_height = dpi(30)
theme.wibar_width = dpi(57.5)
theme.menu_width = dpi(240)
theme.rounded = dpi(5) -- window rounded corners
theme.snap_bg = theme.fg_focus
theme.snap_shape = require "helpers".rrect(8)
theme.snap_border_width = dpi(7.5)
theme.widthbar = dpi(8)
theme.border_width = dpi(1)
theme.border_normal = "#2f2f2f"
theme.border_focus = "#5f5f5f"
theme.border_marked = theme.red
theme.titlebar_enabled = true

-- Accent
-- Default: theme.blue
theme.accent = theme.blue

-- Window Switcher (from Bling)
theme.window_switcher_widget_bg = theme.bg_normal-- The bg color of the widget
theme.window_switcher_widget_border_width = dpi(0) -- The border width of the widget
theme.window_switcher_widget_border_radius = dpi(5) -- The border radius of the widget
theme.window_switcher_clients_spacing = dpi(20) -- The space between each client item
theme.window_switcher_client_icon_horizontal_spacing = 5 -- The space between client icon and text
theme.window_switcher_client_width = dpi(150) -- The width of one client widget
theme.window_switcher_client_height = dpi(150) -- The height of one client widget
theme.window_switcher_client_margins = dpi(10) -- The margin between the content and the border of the widget
theme.window_switcher_thumbnail_margins = dpi(5) -- The margin between one client thumbnail and the rest of the widget
theme.thumbnail_scale = false -- If set to true, the thumbnails fit policy will be set to "fit" instead of "auto"
theme.window_switcher_name_margins = dpi(2.5) -- The margin of one clients title to the rest of the widget
theme.window_switcher_name_valign = "center" -- How to vertically align one clients title
theme.window_switcher_name_forced_width = dpi(250) -- The width of one title
theme.window_switcher_name_font = theme.font -- The font of all titles
theme.window_switcher_name_normal_color = theme.fg_normal -- The color of one title if the client is unfocused
theme.window_switcher_name_focus_color = theme.accent -- The color of one title if the client is focused
theme.window_switcher_icon_valign = "center" -- How to vertically align the one icon
theme.window_switcher_icon_width = dpi(40)

-- Taglist and tasklist
theme.taglist_bg_focus = theme.accent
theme.taglist_fg_focus = "#000000"
theme.taglist_fg_empty = "#f0f0f0"
theme.taglist_fg_occupied = "#fafafa"
theme.taglist_bg_occupied = theme.altnormal
theme.taglist_bg_empty = "#000000" .. "00"
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_fg_urgent = theme.bg_normal
theme.tasklist_bg_normal = theme.altnormal2
theme.tasklist_bg_focus = theme.altnormal3
theme.tasklist_bg_minimize = theme.altnormal .. "30"
theme.tasklist_fg_minimize = theme.fg_normal
theme.tasklist_fg_urgent = theme.bg_normal
theme.tasklist_bg_urgent = theme.red

-- System Tray
theme.bg_systray = theme.altnormal2
theme.systray_icon_spacing = dpi(7.5)

-- Variables set for theming notifications:
-- Notification
theme.notification_spacing = dpi(5)
theme.notification_icon_resize_strategy = "center"
-- Hotkeys
theme.hotkeys_group_margin = dpi(20)
theme.hotkeys_font = theme.font_bold
theme.hotkeys_description_font = theme.font
theme.hotkeys_modifiers_fg = theme.fg_focus
theme.hotkeys_bg = theme.bg_normal

-- You can use your own layout icons like this:
theme.layout_fairh = gfs.get_themes_dir() .. "default/layouts/fairhw.png"
theme.layout_fairv = gfs.get_themes_dir() .. "default/layouts/fairvw.png"
theme.layout_floating = gfs.get_themes_dir() .. "default/layouts/floatingw.png"
theme.layout_magnifier = gfs.get_themes_dir() .. "default/layouts/magnifierw.png"
theme.layout_max = gfs.get_themes_dir() .. "default/layouts/maxw.png"
theme.layout_fullscreen = gfs.get_themes_dir() .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = gfs.get_themes_dir() .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = gfs.get_themes_dir() .. "default/layouts/tileleftw.png"
theme.layout_tile = gfs.get_themes_dir() .. "default/layouts/tilew.png"
theme.layout_tiletop = gfs.get_themes_dir() .. "default/layouts/tiletopw.png"
theme.layout_spiral = gfs.get_themes_dir() .. "default/layouts/spiralw.png"
theme.layout_dwindle = gfs.get_themes_dir() .. "default/layouts/dwindlew.png"
theme.layout_cornernw = gfs.get_themes_dir() .. "default/layouts/cornernww.png"
theme.layout_cornerne = gfs.get_themes_dir() .. "default/layouts/cornernew.png"
theme.layout_cornersw = gfs.get_themes_dir() .. "default/layouts/cornersww.png"
theme.layout_cornerse = gfs.get_themes_dir() .. "default/layouts/cornersew.png"

-- For tabbed only
theme.tabbed_spawn_in_tab = false -- whether a new client should spawn into the focused tabbing container

-- For tabbar in general
theme.tabbar_ontop = false
theme.tabbar_radius = 5 -- border radius of the tabbar
theme.tabbar_style = "default" -- style of the tabbar ("default", "boxes" or "modern")
theme.tabbar_font = theme.font .. "12" -- font of the tabbar
theme.tabbar_size = dpi(35) -- size of the tabbar
theme.tabbar_position = "top" -- position of the tabbar
theme.tabbar_bg_normal = theme.titlebar_bg_normal -- background color of the focused client on the tabbar
theme.tabbar_fg_normal = theme.fg_normal .. "80" -- foreground color of the focused client on the tabbar
theme.tabbar_bg_focus = theme.titlebar_bg_focus -- background color of unfocused clients on the tabbar
theme.tabbar_fg_focus = theme.fg_focus -- foreground color of unfocused clients on the tabbar
theme.tabbar_bg_focus_inactive = nil -- background color of the focused client on the tabbar when inactive
theme.tabbar_fg_focus_inactive = nil -- foreground color of the focused client on the tabbar when inactive
theme.tabbar_bg_normal_inactive = nil -- background color of unfocused clients on the tabbar when inactive
theme.tabbar_fg_normal_inactive = nil -- foreground color of unfocused clients on the tabbar when inactive
theme.tabbar_disable = false -- disable the tab bar entirely

theme.titlebar_close_button_normal = gears.color.recolor_image(titlebar_assets_path .. "close.svg", theme.altnormal)
theme.titlebar_close_button_focus = gears.color.recolor_image(titlebar_assets_path .. "close.svg", theme.fg_focus)
theme.titlebar_maximized_button_normal_active =
    gears.color.recolor_image(titlebar_assets_path .. "restore.svg", theme.altnormal)
theme.titlebar_maximized_button_normal_inactive =
    gears.color.recolor_image(titlebar_assets_path .. "maximize.svg", theme.altnormal)
theme.titlebar_maximized_button_focus_active =
    gears.color.recolor_image(titlebar_assets_path .. "restore.svg", theme.fg_focus)
theme.titlebar_maximized_button_focus_inactive =
    gears.color.recolor_image(titlebar_assets_path .. "maximize.svg", theme.fg_focus)
theme.titlebar_minimize_button_normal =
    gears.color.recolor_image(titlebar_assets_path .. "minimize.svg", theme.altnormal)
theme.titlebar_minimize_button_focus = gears.color.recolor_image(titlebar_assets_path .. "minimize.svg", theme.fg_focus)
theme.titlebar_minimize_button_hover =
    gears.color.recolor_image(titlebar_assets_path .. "minimize.svg", theme.fg_focus .. "90")

theme.titlebar_maximized_button_normal_inactive_hover =
    gears.color.recolor_image(titlebar_assets_path .. "maximize.svg", theme.fg_focus .. "90")
theme.titlebar_maximized_button_normal_active_hover =
    gears.color.recolor_image(titlebar_assets_path .. "restore.svg", theme.fg_focus .. "90")
theme.titlebar_maximized_button_focus_inactive_hover =
    gears.color.recolor_image(titlebar_assets_path .. "maximize.svg", theme.fg_focus .. "90")
theme.titlebar_maximized_button_focus_active_hover =
    gears.color.recolor_image(titlebar_assets_path .. "restore.svg", theme.fg_focus .. "90")
theme.titlebar_close_button_normal_hover =
    gears.color.recolor_image(titlebar_assets_path .. "close.svg", theme.fg_focus .. "90")
theme.titlebar_close_button_focus_hover =
    gears.color.recolor_image(titlebar_assets_path .. "close.svg", theme.fg_focus .. "90")
theme.titlebar_minimize_button_normal_hover =
    gears.color.recolor_image(titlebar_assets_path .. "minimize.svg", theme.fg_focus .. "90")
theme.titlebar_minimize_button_focus_hover =
    gears.color.recolor_image(titlebar_assets_path .. "minimize.svg", theme.fg_focus .. "90")

theme.tag_preview_widget_border_radius = 5 -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = 5 -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 1 -- Opacity of each client
theme.tag_preview_client_bg = theme.bg_focus -- The bg color of each client
theme.tag_preview_client_border_width = dpi(1) -- The border width of each client
theme.tag_preview_widget_bg = theme.bg_normal -- The bg color of the widget
theme.tag_preview_widget_border_width = dpi(0) -- The border width of the widget
theme.tag_preview_widget_margin = dpi(5) -- The margin of the widget

-- Wallpaper
theme.pfp = themes_path .. "pfp.svg"
theme.wall = themes_path .. "wall.jpg"

-- Define the icon theme
theme.icon_theme = nil

return theme
