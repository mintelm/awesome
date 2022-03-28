local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful.xresources').apply_dpi

local shapes = require('modules.shapes')
local widgets = require(... .. '.widgets')

local function rounded_widget(w)
    if w == nil or next(w) == nil then
        return nil
    end

    return {
        {
            w,
            bg = beautiful.xcolor0,
            shape = shapes.rrect(beautiful.border_radius + 2),
            widget = wibox.container.background
        },
        margins = dpi(3),
        widget = wibox.container.margin
    }
end

local function wrap_widget(w)
    if w == nil or next(w) == nil then
        return nil
    end

    return {
        w,
        top = dpi(4),
        left = dpi(7),
        bottom = dpi(4),
        right = dpi(7),
        widget = wibox.container.margin
    }
end

local function top_panel(s)
    local panel = awful.wibar({ position = 'top', screen = s, height = beautiful.top_panel_size })
    local textclock = wibox.widget.textclock('%H:%M')
    textclock:connect_signal('mouse::enter', function() textclock.format = '%a %b %d, %H:%M' end)
    textclock:connect_signal('mouse::leave', function() textclock.format = '%H:%M' end)
    awful.widget.calendar_popup.month():attach(textclock, 'tr', { on_hover = false })
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
    local tasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button(
                { },
                1,
                function (c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c:emit_signal('request::activate', 'tasklist', { raise = true })
                    end
                end
            ),
            awful.button( { }, 4, function () awful.client.focus.byidx(1) end),
            awful.button( { }, 5, function () awful.client.focus.byidx(-1) end)
        },
        style = {
            shape = shapes.rrect(beautiful.border_radius),
        },
        layout = { spacing = dpi(8), layout = wibox.layout.fixed.horizontal },
        widget_template = {
            {
                awful.widget.clienticon,
                top = dpi(1),
                left = dpi(7),
                bottom = dpi(1),
                right = dpi(7),
                layout = wibox.container.margin,
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c, index, clients)
                self:connect_signal('mouse::enter', function()
                    self.bg = beautiful.tasklist_bg_normal .. '400'
                end)
                self:connect_signal('mouse::leave', function()
                    if c.minimized then
                        self.bg = beautiful.tasklist_bg_minimize
                    else
                        self.bg = beautiful.tasklist_bg_normal
                    end
                end)
            end
        },
    }

    panel:setup {
        -- top (empty)
        nil,
        -- middle (main panel)
        {
            -- left
            {
                rounded_widget(wrap_widget(taglist)),
                layout = wibox.layout.align.horizontal,
            },
            -- middle
            {
                wrap_widget(tasklist),
                layout = wibox.layout.align.horizontal,
            },
            -- right
            {
                {
                    screen = 'primary',
                    rounded_widget(wrap_widget(wibox.widget.systray())),
                    layout = awful.widget.only_on_screen,
                },
                rounded_widget(wrap_widget(widgets.battery)),
                rounded_widget(wrap_widget(layoutbox)),
                rounded_widget(wrap_widget(textclock)),
                layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.align.horizontal,
            expand = 'none',
        },
        -- bottom (accent line)
        {
            widget = wibox.container.background,
            bg = beautiful.xcolor0,
            forced_height = beautiful.border_width,
        },
        layout = wibox.layout.align.vertical,
    }

    return panel
end

screen.connect_signal(
    'request::desktop_decoration',
    function(s)
        s.top_panel = top_panel(s)
    end
)
