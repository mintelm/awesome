local awful = require('awful')
local beautiful = require('beautiful')

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
            if (c.floating or c.first_tag.layout.name == 'floating') then
                awful.titlebar.show(c)
                c : relative_move(0, 0, 0, - beautiful.titlebar_size)
            else
                awful.titlebar.hide(c)
            end
            c.last_layout = c.first_tag.layout.name
        end
    end
)
