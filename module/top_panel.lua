local awful = require('awful')
local wibox = require('wibox')

local top_panel = function(s)
    local panel = awful.wibar({ position = 'top', screen = s })
    local mytextclock = wibox.widget.textclock()
    local mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }
    local mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = {
            awful.button({ }, 1, function(t) t : view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    panel.widget = {
        layout = wibox.layout.align.horizontal,
        expand = 'none',
        -- left
        {
            layout = wibox.layout.align.horizontal,
            mytaglist,
        },
        -- middle
        {
            layout = wibox.layout.align.horizontal,
            mytextclock,
        },
        -- right
        {
            layout = wibox.layout.align.horizontal,
            wibox.widget.systray(),
            mylayoutbox,
        }
    }

    return panel
end

return top_panel
