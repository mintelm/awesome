local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful.xresources').apply_dpi

local shapes = require('modules.shapes')
local battery = require('modules.battery')

local function rounded_widget(widget, top, bottom, left, right, bg)
    -- check if widget is a table
    if next(widget) == nil then
        return nil
    end

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

function top_panel(s)
    local top_panel = awful.wibar({ position = 'top', screen = s, height = beautiful.top_panel_size })
    local textclock = wibox.widget.textclock()
    local layoutbox = awful.widget.layoutbox {
        screen = s,
        shape = shapes.rrect(beautiful.border_radius),
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }
    local taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        buttons = {
            awful.button(
                { },
                1,
                function(t) t:view_only() end
            ),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    top_panel:setup {
        -- top (empty)
        nil,
        -- middle (main panel)
        {
            -- left
            {
                layout = wibox.layout.align.horizontal,
                rounded_widget(taglist, dpi(4), dpi(4), dpi(7), dpi(7), beautiful.xcolor0)
            },
            -- middle
            {
                layout = wibox.layout.align.horizontal,
                textclock,
            },
            -- right
            {
                {
                    rounded_widget(wibox.widget.systray(), dpi(1), dpi(1), dpi(8), dpi(8), beautiful.xcolor0),
                    layout = awful.widget.only_on_screen,
                    screen = 'primary'
                },
                rounded_widget(battery, dpi(4), dpi(4), dpi(7), dpi(7), beautiful.xcolor0),
                rounded_widget(layoutbox, dpi(4), dpi(4), dpi(7), dpi(7), beautiful.xcolor0),
                layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.align.horizontal,
            expand = 'none',
        },
        -- bottom (accent line)
        {
            widget = wibox.container.background,
            bg = beautiful.xcolor0,
            forced_height = beautiful.border_width
        },
        layout = wibox.layout.align.vertical,
    }

    return top_panel
end

screen.connect_signal(
    'request::desktop_decoration',
    function(s)
        s.top_panel = top_panel(s)
    end
)
