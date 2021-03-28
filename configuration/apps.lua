local auto_start = require('module.auto_start')

local apps = {}

apps.default = {
    terminal = 'alacritty',
    web_browser = 'google-chrome-stable',
    run_menu = 'rofi -show run -theme gruvbox.rasi -lines 7'
}

apps.auto_start = {
    'nm-applet',
    'eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh)',
    --'picom --experimental-backends',
    'element-desktop --hidden'
}

for _, app in ipairs(apps.auto_start) do
    auto_start.run_once(app)
end

return apps
