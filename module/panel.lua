local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful.xresources').apply_dpi

local shapes = require('module.shapes')

local panel = {}

local function rounded_widget(widget, top, bottom, left, right, bg)
    return {
        {
            {
                widget,
                top = top,
                bottom = bottom,
                left = left,
                right = right,
                widget = wibox.container.margin
            },
            bg = bg,
            shape = shapes.rrect(beautiful.border_radius + 2),
            widget = wibox.container.background
        },
        margins = dpi(3),
        widget = wibox.container.margin
    }
end

function panel.top_panel(s)
    local top_panel = awful.wibar({ position = 'top', screen = s })
    local mytextclock = wibox.widget.textclock()
    local mylayoutbox = awful.widget.layoutbox {
        screen = s,
        shape = shapes.rrect(beautiful.border_radius),
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }
    local mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        buttons = {
            awful.button(
                { },
                1,
                function(t) t:view_only() end
            ),
            awful.button(
                { modkey },
                1,
                function(t)
                    if client.focus then
                        client.focus:move_to_tag(t)
                    end
                end
            ),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button(
                { modkey },
                3,
                function(t)
                    if client.focus then
                        client.focus:toggle_tag(t)
                    end
                end
            ),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    top_panel:setup {
        layout = wibox.layout.align.horizontal,
        expand = 'none',
        -- left
        {
            layout = wibox.layout.align.horizontal,
            rounded_widget(mytaglist, dpi(4), dpi(4), dpi(7), dpi(7), beautiful.xcolor0)
        },
        -- middle
        {
            layout = wibox.layout.align.horizontal,
            mytextclock
        },
        -- right
        {
            layout = wibox.layout.align.horizontal,
            {
                rounded_widget(wibox.widget.systray(), dpi(1), dpi(1), dpi(8), dpi(8), beautiful.xcolor0),
                widget = wibox.container.margin,
                layout = awful.widget.only_on_screen,
                screen = 'primary'
            },
            rounded_widget(mylayoutbox, dpi(4), dpi(4), dpi(7), dpi(7), beautiful.xcolor0)
        }
    }

    return top_panel
end

return panel
