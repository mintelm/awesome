local auto_start = require('module.auto_start')
local beautiful = require('beautiful')

local apps = {}

local ext_path = '~/.config/awesome/configuration/ext/'

apps.default = {
    terminal = 'alacritty',
    web_browser = 'google-chrome-stable',
    run_menu = 'rofi -modi drun -show drun -font "' .. beautiful.font_mono .. '" -show-icons \z
               -icone-theme "' .. beautiful.icon_theme .. '" -matching fuzzy -dpi 192 \z
	       -theme ' .. ext_path .. 'gruvbox.rasi'
}

apps.auto_start = {
    'nm-applet',
    'picom --config ' .. ext_path .. 'picom.conf',
}

for _, app in ipairs(apps.auto_start) do
    auto_start.run_once(app)
end

return apps
