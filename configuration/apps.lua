return {
    default = {
        terminal = 'kitty',
        web_browser = 'google-chrome-stable',
        run_menu = 'rofi -show run -theme gruvbox.rasi -lines 7'
    },
    auto_start = {
        'nm-applet',
        'eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh)',
        'picom --experimental-backends',
        'element-desktop --hidden'
    }
}
