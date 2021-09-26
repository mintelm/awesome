local gfs = require('gears.filesystem')
local dpi = require('beautiful.xresources').apply_dpi

local def_theme_path = gfs.get_themes_dir()
local theme_path = gfs.get_configuration_dir() .. '/theme'

local shapes = require('module.shapes')

local theme = {}

-- General
theme.font = 'Noto Sans 9'
theme.font_bold = 'Noto Sans Bold 9'
theme.font_mono = 'MesloLGS Nerd Font 9'
theme.icon_theme = 'WhiteSur-dark'
theme.wallpaper = theme_path .. '/wallpapers/jets.jpg'
theme.master_width_factor = 0.55

-- General Color Definitions
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
theme.inactive = '#373737'

theme.bg_normal = theme.xbg
theme.bg_focus = theme.xcolor14
theme.bg_urgent = theme.xcolor1
theme.bg_minimize = theme.xcolor4
theme.bg_systray = theme.xcolor0

theme.fg_normal = theme.xfg
theme.fg_focus = theme.xfg .. 'dd'
theme.fg_urgent = theme.xfg .. 'dd'
theme.fg_minimize = theme.xfg .. 'dd'

-- Decorations
theme.useless_gap = dpi(7)
theme.border_width = dpi(1)
theme.border_radius = dpi(6)
theme.border_normal = theme.inactive
theme.border_focus = theme.bg_focus
theme.fullscreen_hide_border = true
theme.maximized_hide_border = true

theme.titlebar_size = dpi(22)
theme.titlebar_icon_size = dpi(8)
theme.titlebar_bg_focus = theme.bg_normal
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.inactive
theme.titlebar_fg_focus = theme.fg_focus

theme.taglist_bg_focus = theme.xcolor0
theme.taglist_bg_occupied = theme.xcolor0
theme.taglist_fg_focus = theme.bg_focus
theme.taglist_fg_occupied = theme.fg_normal

theme.systray_icon_spacing = dpi(5)

theme.layout_floating  = def_theme_path .. 'default/layouts/floatingw.png'
theme.layout_fullscreen = def_theme_path .. 'default/layouts/fullscreenw.png'
theme.layout_tilebottom = def_theme_path .. 'default/layouts/tilebottomw.png'
theme.layout_tile = def_theme_path .. 'default/layouts/tilew.png'

-- Notifications
theme.notification_shape = shapes.rrect(theme.border_radius)
theme.notification_max_width = dpi(350)
theme.notification_font = theme.font_mono

return theme
