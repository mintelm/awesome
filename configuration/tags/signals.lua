local awful = require('awful')
local beautiful = require('beautiful')

local dynamic_titlebar = require('modules.titlebar').dynamic_titlebar

tag.connect_signal(
    'request::default_layouts',
    function()
        awful.layout.append_default_layouts({
            awful.layout.suit.tile,
            awful.layout.suit.tile.bottom,
            awful.layout.suit.floating
        })
    end
)

tag.connect_signal(
    'property::layout',
    function(t)
        local clients = t : clients()
        for _,c in pairs(clients) do
            if c.fullscreen then
                c.fullscreen = not c.fullscreen
            end
            if c.maximized then
                c.maximized = not c.maximized
            end

            dynamic_titlebar(c)
        end
    end
)
