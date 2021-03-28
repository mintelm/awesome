local awful = require('awful')
local beautiful = require('beautiful')

local titlebar = require('module.titlebar')

client.connect_signal(
    'request::titlebars',
    function(c)
        titlebar.top_titlebar(c)
    end
)

client.connect_signal(
    'tagged',
    function(c)
        titlebar.dynamic_titlebar(c)
        -- let awesome do the rescaling if maximized clients are tagged
        if c.maximized then
            c.maximized = not c.maximized
            c.maximized = not c.maximized
        end
    end
)

client.connect_signal(
    'property::fullscreen',
    function(c)
        if c.first_tag.layout.name == 'floating' then
            awful.titlebar.toggle(c)
            -- resize to compensate for titlebar.toggle
            if c.fullscreen then
                c:relative_move(0, 0, 0, beautiful.titlebar_size)
            else
                c:relative_move(0, 0, 0, - beautiful.titlebar_size)
            end
        end
    end
)
