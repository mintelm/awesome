local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')

local top_panel = require('module.panel').top_panel

screen.connect_signal(
    'request::desktop_decoration',
    function(s)
        awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8', '9' }, s, awful.layout.suit.floating)
        s.top_panel = top_panel(s)
    end
)

screen.connect_signal(
    'request::wallpaper',
    function(s)
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            if type(wallpaper) == 'function' then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
)
