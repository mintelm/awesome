local awful = require('awful')
local beautiful = require('beautiful')

local top_titlebar = require('configuration.client.titlebar')

function dynamic_title(c)
    if c.floating or c.first_tag.layout.name == 'floating' then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end

client.connect_signal(
    'request::titlebars',
    function(c)
        top_titlebar(c)
    end
)

client.connect_signal(
    'tagged',
    function(c)
        if c.last_layout ~= 'floating' and not c.maximized then
            c : relative_move(0, 0, 0, - beautiful.titlebar_size)
        end
        dynamic_title(c)
        c.last_layout = c.first_tag.layout.name
    end
)
