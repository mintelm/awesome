---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local icon_path = gfs.get_configuration_dir() .. "/icons/"

local theme = {}

theme.font          = "noto sans display medium 8"
theme.clock_font    = "noto sans display bold 10"

theme.bg_normal     = "#3c3836"
theme.bg_focus      = "#282828"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#ebdbb2"
theme.fg_focus      = "#fbf1c7"
theme.fg_urgent     = "#fbf1c7"
theme.fg_minimize   = "#fbf1c7"

theme.useless_gap   = dpi(4)
theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = "#a89984"
theme.border_marked = "#91231c"

theme.wibar_bg      = theme.bg_focus
theme.wibar_height  = 32

theme.taglist_bg_focus = "#fe8019"

theme.bg_systray    = theme.bg_focus

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.taglist_bg_focus
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
theme.notification_font = "noto sans display medium 12"

theme.menu_height = dpi(15)

-- Define the image to load
theme.titlebar_close_button_normal = icon_path .. "close.png"
theme.titlebar_close_button_focus  = icon_path .. "close.png"

theme.wallpaper = "/usr/share/backgrounds/psy_forest.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
