local gears = require('gears')
local dpi = require('beautiful.xresources').apply_dpi

local theme_dir = gears.filesystem.get_configuration_dir() .. '/theme'
local titlebar_icon_path = theme_dir .. '/icons/titlebar/'
local tip = titlebar_icon_path

local theme = {}

-- General
theme.font = 'TeX Gyre Heros Regular 9'
theme.font_bold = 'TeX Gyre Heros Bold 9'
theme.icon_theme = 'WhiteSur-dark'
theme.wallpaper = theme_dir .. '/wallpapers/zelda_art.jpg'

-- Colors
theme.xbg = '#1d2021'
theme.xfg = '#eeeeec'
theme.xcolor0 = '#2e3436'
theme.xcolor1 = '#cc0000'
theme.xcolor2 = '#73d216'
theme.xcolor3 = '#edd400'
theme.xcolor4 = '#4881c0'
theme.xcolor5 = '#75507b'
theme.xcolor6 = '#d65d0e'
theme.xcolor7 = '#d3d7cf'
theme.xcolor8 = '#2e3436'
theme.xcolor9 = '#ef2929'
theme.xcolor10 = '#8ae234'
theme.xcolor11 = '#fce94f'
theme.xcolor12 = '#80a4d4'
theme.xcolor13 = '#ad7fa8'
theme.xcolor14 = '#fe8019'
theme.xcolor15 = '#eeeeec'

-- Borders
theme.border_normal = '#373737'
theme.border_width = dpi(1)
theme.border_focus = theme.xcolor14
theme.fullscreen_hide_border = true
theme.maximized_hide_border = true

-- Decorations
theme.useless_gap = dpi(7)
theme.master_width_factor = 0.55

-- Titlebar
theme.titlebar_size = dpi(22)
theme.titlebar_icon_size = dpi(8)
theme.titlebar_bg_focus = theme.xbg
theme.titlebar_bg_normal = theme.xbg
theme.titlebar_fg_normal = theme.xcolor8
theme.titlebar_fg_focus = theme.xcolor15 .. 'dd'
theme.taglist_fg_focus = '#fe8019'
theme.taglist_fg_occupied = '#373737'

return theme
