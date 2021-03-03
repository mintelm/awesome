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
