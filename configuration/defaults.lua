local awful = require('awful')
local beautiful = require('beautiful')

local defaults = { }

local ext_path = '~/.config/awesome/configuration/ext/'

defaults.mod_keys = {
    mod_key = 'Mod4',
    alt_key = 'Mod1',
}

defaults.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
}

defaults.tags = { '1', '2', '3', '4', '5', '6', '7', '8', '9' }

defaults.apps = {
    terminal = 'alacritty',
    web_browser = 'google-chrome-stable',
    run_menu = 'rofi -modi drun -show drun -font "' .. beautiful.font_mono .. '" -show-icons \z
               -icone-theme "' .. beautiful.icon_theme .. '" -matching fuzzy -dpi 192 \z
               -theme ' .. ext_path .. 'gruvbox.rasi',
}

defaults.auto_start = {
    'nm-applet',
    'picom --config ' .. ext_path .. 'picom.conf',
}

return defaults
