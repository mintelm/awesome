local gears = require('gears')

local filesystem = gears.filesystem
local dpi = require('beautiful.xresources').apply_dpi

local theme_dir = filesystem.get_configuration_dir() .. '/theme'
local titlebar_icon_path = theme_dir .. '/icons/titlebar/'
local tip = titlebar_icon_path

local theme = { }

-- General
theme.font          = 'TeX Gyre Heros Regular 9'
theme.font_bold     = 'TeX Gyre Heros Bold 9'

theme.icon_theme    = 'WhiteSur-dark'

theme.wallpaper     = theme_dir .. '/wallpapers/zelda_art.jpg'

-- Borders
theme.border_normal             = '#373737'
theme.border_width              = dpi(1)
theme.border_focus              = '#fe8019'
theme.fullscreen_hide_border    = true
theme.maximized_hide_border     = true

-- Decorations
theme.useless_gap           = dpi(7)
theme.master_width_factor   = 0.55

-- Titlebar
theme.titlebar_size = dpi(22)
theme.taglist_fg_focus = '#fe8019'
theme.taglist_fg_occupied = '#373737'

-- Close Button
theme.titlebar_close_button_normal          = tip .. 'close_normal.svg'
theme.titlebar_close_button_normal_hover    = tip .. 'close_normal_hover.svg'
theme.titlebar_close_button_focus           = tip .. 'close_focus.svg'
theme.titlebar_close_button_focus_hover     = tip .. 'close_focus_hover.svg'

return theme
